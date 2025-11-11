import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:near_voice/data/services/photo_service.dart';

class EditPicturesPage extends StatefulWidget {
  const EditPicturesPage({super.key});

  @override
  State<EditPicturesPage> createState() => _EditPicturesPageState();
}

class _EditPicturesPageState extends State<EditPicturesPage> {
  final photoService = PhotoService();
  List<Map<String, dynamic>> photos = [];
  bool isLoading = true;

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

    final url = await photoService.uploadPhoto(user.id);
    if (url != null) await loadPhotos();
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
    return Scaffold(
      appBar: AppBar(title: const Text('Fotoğraflarımı Düzenle')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                          Image.network(photo['photo_url'], fit: BoxFit.cover),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () =>
                                  deletePhoto(photo['id'], photo['photo_url']),
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
                ElevatedButton.icon(
                  onPressed: photos.length < 3 ? addPhoto : null,
                  icon: const Icon(Icons.add),
                  label: const Text('Yeni Fotoğraf Ekle'),
                ),
                const SizedBox(height: 12),
              ],
            ),
    );
  }
}
