import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/core/widgets/sign_button.dart';
import 'package:near_voice/data/services/photo_service.dart';
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
  bool _isUploading = false;

  Future<void> loadPhotos() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final data = await photoService.getUserPhotos(user.id);
    setState(() {
      photos = data;
      isLoading = false;
    });
  }

  Future<void> addPhoto() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final url = await photoService.uploadPhoto(user.id);
      if (url != null) {
        await loadPhotos();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fotoğraf yüklenemedi: $e')));
      }
    } finally {
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

    if (isLoading) {
      return Scaffold(
        body: GradientBackground(
          linearGradient: AppColor.backgroundGradient,
          child: const Center(child: CircularProgressIndicator()),
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
              // 🔹 Header
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
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
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

              // 🔹 Linear Progress Bar
              if (_isUploading)
                Center(
                  child: const LinearProgressIndicator(
                    color: AppColor.purple500,
                    backgroundColor: AppColor.white10,
                  ),
                )
              else
                const SizedBox(),

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
                      SizedBox(
                        height: width * 1.25,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: photos.length,
                          itemBuilder: (context, index) {
                            final photo = photos[index];

                            return Container(
                              width: width * 0.94, // 📌 Padding'leri hesaba kat
                              margin: const EdgeInsets.only(right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // 📌 AspectRatio ile fotoğrafın bozulmasını önlüyoruz
                                    AspectRatio(
                                      aspectRatio: 4 / 5,
                                      child: Image.network(
                                        photo['photo_url'],
                                        fit: BoxFit.cover,
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
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 12),
                      photos.length < 3
                          ? SignButton(
                              onTap: isLoading
                                  ? () {}
                                  : (photos.length < 3 && !_isUploading)
                                  ? addPhoto
                                  : () {},
                              text: _isUploading
                                  ? 'Yükleniyor...'
                                  : 'Yeni Fotoğraf Ekle',
                            )
                          : SizedBox(),
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
