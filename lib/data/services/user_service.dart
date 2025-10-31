import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient _client = Supabase.instance.client;

  /// 🟢 Yeni kullanıcı ekle
  Future<void> insertUser({
    required String username,
    required String birthDate,
    required String gender,
    required double latitude,
    required double longitude,
    required String authUserId,
  }) async {
    final response = await _client.from('user').insert({
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

  /// ✏️ Kullanıcı güncelle (eski alanlar)
  Future<void> updateUser({
    required int id,
    String? username,
    String? gender,
    double? latitude,
    double? longitude,
  }) async {
    final updateData = {
      if (username != null) 'user_name': username,
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

  /// 🔹 Yeni alanlar için ayrı update fonksiyonları

  Future<void> updateAbout({required int id, required String about}) async {
    final response = await _client
        .from('user')
        .update({
          'about': about,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id);
    print('updateAbout → $response');
  }

  Future<void> updateMinAge({required int id, required int minAge}) async {
    final response = await _client
        .from('user')
        .update({
          'min_age': minAge,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id);
    print('updateMinAge → $response');
  }

  Future<void> updateMaxAge({required int id, required int maxAge}) async {
    final response = await _client
        .from('user')
        .update({
          'max_age': maxAge,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id);
    print('updateMaxAge → $response');
  }

  Future<void> updateMaxDistance({
    required int id,
    required int maxDistance,
  }) async {
    final response = await _client
        .from('user')
        .update({
          'max_distance': maxDistance,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id);
    print('updateMaxDistance → $response');
  }

  Future<void> updateInterests({
    required int id,
    required String interests,
  }) async {
    final response = await _client
        .from('user')
        .update({
          'interests': interests,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id);
    print('updateInterests → $response');
  }

  /// 🔹 Mevcut kullanıcı detaylarını getir
  Future<Map<String, dynamic>?> getCurrentUserDetails() async {
    final authUserId = Supabase.instance.client.auth.currentUser?.id;
    if (authUserId == null) return null;

    final response = await Supabase.instance.client
        .from('user')
        .select()
        .eq('auth_user_id', authUserId)
        .maybeSingle(); // Tek kullanıcı alıyoruz
    print("User: $response");
    return response;
  }
}
