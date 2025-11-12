// 'image' paketini artık burada import etmene gerek kalmadı.
// import 'package:image/image.dart' as img;
import 'dart:typed_data'; // Byte listesi (Uint8List) için bu gerekli
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PhotoService {
  final SupabaseClient _client = Supabase.instance.client;

  /// 📤 Fotoğraf yükle (Sıkıştırma ve Boyutlandırma image_picker ile yapılıyor)
  Future<String?> uploadPhoto(String userId) async {
    try {
      // 1. Mevcut foto sayısını kontrol et (Aynı)
      final existing = await _client
          .from('user_photos')
          .select()
          .eq('auth_user_id', userId);

      if (existing.length >= 3) {
        throw Exception('Maksimum 3 fotoğraf yükleyebilirsin.');
      }

      // 2. Galeriden fotoğraf seç (❗️ BURASI GÜNCELLENDİ)
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,

        // 🌟 SİHİRLİ SATIRLAR 🌟
        maxWidth: 1080.0, // 👈 Genişliği 1080px ile sınırla (oranı korur)
        imageQuality: 85, // 👈 Kaliteyi %85 yap (ve HEIC'i JPG'ye dönüştür)
      );

      if (picked == null) return null;

      // 3. ❗️ DEĞİŞİKLİK ❗️
      // 'image' paketiyle yaptığımız decode/resize/encode adımlarının
      // tamamı SİLİNDİ.
      // Çünkü 'picked' dosyası artık 'image_picker' sayesinde
      // zaten 1080px genişliğinde ve %85 kalitede bir JPEG dosyası.

      // 4. Sıkıştırılmış/Boyutlandırılmış dosyanın byte'larını oku
      final Uint8List fileBytes = await picked.readAsBytes();

      // 5. Dosya adını ve yolunu belirle
      // picked.path artık .jpg veya .jpeg uzantılı olacaktır.
      final fileExtension = extension(picked.path);
      final fileName =
          '${userId}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';

      // 6. Storage’a 'uploadBinary' ile yükle (Aynı)
      await _client.storage
          .from('user_photos')
          .uploadBinary(fileName, fileBytes);

      // 7. Public URL oluştur (Aynı)
      final url = _client.storage.from('user_photos').getPublicUrl(fileName);

      // 8. Veritabanına kaydet (Aynı)
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

  // deletePhoto ve getUserPhotos metodları aynı kalabilir
  // ...
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
