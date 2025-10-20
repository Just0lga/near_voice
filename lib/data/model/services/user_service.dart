import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient _client = Supabase.instance.client;

  /// 🟢 Yeni kullanıcı ekle
  Future<void> insertUser({
    // ❌ 'id' parametresi kaldırıldı. Veritabanı bu değeri otomatik üretecek.
    required String username,
    required String birthDate,
    required String gender,
    required double latitude,
    required double longitude,
    required String
    authUserId, // 💡 ÖNEMLİ: Auth ID'sini saklamak için eklendi (Aşağıdaki notu okuyun)
  }) async {
    final response = await _client.from('user').insert({
      // 🔄 'username' anahtarı, tablodaki gibi 'user_name' olarak düzeltildi.
      'user_name': username,
      'birth_date': birthDate,
      'gender': gender,
      'latitude': latitude,
      'longitude': longitude,
      'auth_user_id': authUserId,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    print('insertUser → $response');
  }

  /// 🔵 Tüm kullanıcıları getir
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await _client.from('user').select();
    return List<Map<String, dynamic>>.from(response);
  }

  /// 🟡 Filtreli kullanıcı getir (örnek: gender='male')
  Future<List<Map<String, dynamic>>> getUsersByGender(String gender) async {
    final response = await _client.from('user').select().eq('gender', gender);

    return List<Map<String, dynamic>>.from(response);
  }

  /// ✏️ Kullanıcı güncelle
  Future<void> updateUser({
    required int id,
    String? username,
    String? gender,
    double? latitude,
    double? longitude,
  }) async {
    final updateData = {
      if (username != null) 'username': username,
      if (gender != null) 'gender': gender,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'updated_at': DateTime.now().toIso8601String(),
    };

    final response = await _client.from('user').update(updateData).eq('id', id);

    print('updateUser → $response');
  }

  /// ❌ Kullanıcı sil
  Future<void> deleteUser(int id) async {
    final response = await _client.from('user').delete().eq('id', id);

    print('deleteUser → $response');
  }
}
