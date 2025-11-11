import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PhotoService {
  final SupabaseClient _client = Supabase.instance.client;

  /// 📤 Fotoğraf yükle (max 3 kontrolü içerir)
  Future<String?> uploadPhoto(String userId) async {
    try {
      // Mevcut foto sayısını kontrol et
      final existing = await _client
          .from('user_photos')
          .select()
          .eq('auth_user_id', userId);

      if (existing.length >= 3) {
        throw Exception('Maksimum 3 fotoğraf yükleyebilirsin.');
      }

      // Galeriden fotoğraf seç
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return null;

      final file = File(picked.path);
      final fileName =
          '${userId}_${DateTime.now().millisecondsSinceEpoch}${extension(file.path)}';

      // Storage’a yükle
      await _client.storage.from('user_photos').upload(fileName, file);

      // Public URL oluştur
      final url = _client.storage.from('user_photos').getPublicUrl(fileName);

      // Veritabanına kaydet
      await _client.from('user_photos').insert({
        'auth_user_id': userId,
        'photo_url': url,
      });

      return url;
    } catch (e) {
      print('Foto yükleme hatası: $e');
      return null;
    }
  }

  /// 🗑️ Fotoğraf sil
  Future<void> deletePhoto(int photoId, String photoUrl) async {
    try {
      final path = photoUrl.split('/user_photos/').last;

      // Storage’tan sil
      await _client.storage.from('user_photos').remove([path]);

      // DB’den sil
      await _client.from('user_photos').delete().eq('id', photoId);
    } catch (e) {
      print('Foto silme hatası: $e');
    }
  }

  /// 📋 Kullanıcının fotoğraflarını getir
  Future<List<Map<String, dynamic>>> getUserPhotos(String userId) async {
    final res = await _client
        .from('user_photos')
        .select()
        .eq('auth_user_id', userId)
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(res);
  }
}
