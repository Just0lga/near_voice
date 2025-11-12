import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/core/widgets/sign_button.dart';
import 'package:near_voice/core/helpers/auth_gate.dart';
import 'package:near_voice/data/services/photo_service.dart';
import 'package:near_voice/data/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPicturesPage extends StatefulWidget {
  const EditPicturesPage({super.key});

  @override
  State<EditPicturesPage> createState() => _EditPicturesPageState();
}

class _EditPicturesPageState extends State<EditPicturesPage> {
  final photoService = PhotoService();
  List<Map<String, dynamic>> photos = [];
  bool isLoading = true;
  bool _isUploading = false; // 👈 1. YENİ STATE DEĞİŞKENİ

  Future<void> loadPhotos() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final data = await photoService.getUserPhotos(user.id);
    setState(() {
      photos = data;
      isLoading = false;
    });
  }

  // 👈 2. ADDPHOTO METODU GÜNCELLENDİ
  Future<void> addPhoto() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() {
      _isUploading = true; // Yüklemeyi başlat
    });

    try {
      final url = await photoService.uploadPhoto(user.id);
      if (url != null) {
        await loadPhotos(); // Yükleme başarılıysa fotoğrafları yenile
      }
    } catch (e) {
      // photoService'de hata yakalama zaten var ama burada da ekleyebiliriz
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fotoğraf yüklenemedi: $e')));
      }
    } finally {
      // Hata alsa da almasa da yüklemeyi bitir
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> deletePhoto(int photoId, String photoUrl) async {
    await photoService.deletePhoto(photoId, photoUrl);
    await loadPhotos();
  }

  @override
  void initState() {
    super.initState();
    loadPhotos();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Bu if bloğu sadece sayfa ilk açıldığındaki yükleme içindir
    if (isLoading) {
      return const Scaffold(
        body: GradientBackground(
          linearGradient: AppColor.backgroundGradient,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Scaffold(
      body: GradientBackground(
        linearGradient: AppColor.backgroundGradient,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 Header (Aynı)
              Container(
                width: width,
                decoration: BoxDecoration(
                  color: AppColor.white5,
                  border: Border(bottom: BorderSide(color: AppColor.white10)),
                ),
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: width * 0.03),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: width * 0.02),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: AppColor.white60,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              text: "Fotoğraflarım",
                              textFontSize: width * 0.055,
                              textHeight: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 👈 3. LİNEER PROGRESS BAR EKLENDİ
              if (_isUploading)
                const LinearProgressIndicator(
                  color: AppColor.purple500, // Temana uygun bir renk
                  backgroundColor: AppColor.white10,
                )
              else
                // Yükleme yokken, indicator'ün yüksekliği kadar (varsayılan 4.0)
                // bir boşluk bırak ki ekran "zıplamasın".
                const SizedBox(height: 4.0),

              // 🟣 Body
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.02,
                    horizontal: width * 0.03,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemCount: photos.length,
                          itemBuilder: (context, index) {
                            final photo = photos[index];
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  photo['photo_url'],
                                  fit: BoxFit.cover,
                                  // 👈 Resim yüklenirken de bir indicator gösterelim
                                  loadingBuilder:
                                      (
                                        BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress,
                                      ) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: AppColor.purple400,
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => deletePhoto(
                                      photo['id'],
                                      photo['photo_url'],
                                    ),
                                    child: const CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.black54,
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      // 👈 4. BUTON GÜNCELLENDİ
                      ElevatedButton.icon(
                        // Yükleme varsa veya fotoğraf limiti doluysa butonu pasif yap
                        onPressed: (photos.length < 3 && !_isUploading)
                            ? addPhoto
                            : null,
                        icon: const Icon(Icons.add),
                        label: Text(
                          // Yükleme varsa metni değiştir
                          _isUploading ? 'Yükleniyor...' : 'Yeni Fotoğraf Ekle',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.purple500,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColor.slate800,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
