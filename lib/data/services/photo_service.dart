import 'dart:typed_data'; // Byte listesi (Uint8List) için bu gerekli
import 'package:flutter/material.dart'; // Renkler için eklendi
import 'package:image_cropper/image_cropper.dart'; // <-- 1. YENİ IMPORT
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PhotoService {
  final SupabaseClient _client = Supabase.instance.client;

  /// 📤 Fotoğraf yükle (Sıkıştırma, Boyutlandırma ve 4:5 Kırpma)
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

      // 2. Galeriden fotoğraf seç (❗️ AYARLAR KALDIRILDI)
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        // maxWidth ve imageQuality ayarları buradan kaldırıldı.
        // Bu işlemleri cropper'da yapacağız.
      );

      if (picked == null) return null; // Kullanıcı seçim yapmadı

      // 3. 🌟 YENİ ADIM: FOTOĞRAFI KIRPMA (4:5 ORANINDA) 🌟
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: picked.path,
        // İstenen 4:5 oranı ve sıkıştırma kalitesi
        aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 5),
        compressQuality: 85, // Kaliteyi %85 yap
        maxWidth: 1080, // Genişliği 1080px ile sınırla
        // Kırpma arayüzünün görünüm ayarları (Opsiyonel ama güzel)
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Fotoğrafı Kırp',
            toolbarColor: const Color(0xFF0F172A), // slate900
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio4x3, // İlk açılış
            lockAspectRatio: true, // Oranı kilitle (Sadece 4:5)
            activeControlsWidgetColor: const Color(0xFFA855F7), // purple500
          ),
          IOSUiSettings(
            title: 'Fotoğrafı Kırp',
            aspectRatioPickerButtonHidden: true,
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioLockDimensionSwapEnabled: true,
            rectX: 4, // 4:5 oranını direkt uygula
            rectY: 5,
          ),
        ],
      );

      // 4. Kullanıcı kırpmayı iptal ederse
      if (croppedFile == null) return null;

      // 5. Kırpılmış dosyanın byte'larını oku
      final Uint8List fileBytes = await croppedFile.readAsBytes();

      // 6. Dosya adını ve yolunu belirle
      final fileExtension = extension(
        croppedFile.path,
      ); // Kırpılan dosyanın yolunu kullan
      final fileName =
          '${userId}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';

      // 7. Storage’a 'uploadBinary' ile yükle (Aynı)
      await _client.storage
          .from('user_photos')
          .uploadBinary(fileName, fileBytes);

      // 8. Public URL oluştur (Aynı)
      final url = _client.storage.from('user_photos').getPublicUrl(fileName);

      // 9. Veritabanına kaydet (Aynı)
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
