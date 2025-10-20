import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in with email and password
  Future<AuthResponse> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
    required String gender,
    required String birthDate,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'username': username, // Kullanıcı adı
        'gender': gender, // Cinsiyet
        'birth_date': birthDate, // Doğum tarihi (YYYY-MM-DD formatında)
        'preferred_language': "tr",
      },
    );
  }

  // Auth TOKEN
  String? getAuth() {
    final session = _supabase.auth.currentSession;
    return session?.accessToken; // JWT token burada
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Current user info
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  // Change language - Düzeltilmiş
  Future<void> updateLanguage(String newLanguage) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        print("Kullanıcı oturum açmamış");
        return;
      }

      // Mevcut user_metadata'yı al ve güncelle
      final currentMetadata = Map<String, dynamic>.from(
        user.userMetadata ?? {},
      );
      currentMetadata['preferred_language'] = newLanguage;

      final response = await _supabase.auth.updateUser(
        UserAttributes(
          data: currentMetadata, // data parametresi kullan, userMetadata değil
        ),
      );

      if (response.user != null) {
        print("Dil başarıyla güncellendi: $newLanguage");
      } else {
        print("Dil güncellenirken hata oluştu");
      }
    } catch (e) {
      print("Dil güncelleme hatası: $e");
    }
  }

  // Get current language - Düzeltilmiş
  String? getLanguage() {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        print("Kullanıcı oturum açmamış");
        return null;
      }

      // userMetadata'dan preferred_language'ı al
      final language = user.userMetadata?['preferred_language'] as String?;
      return language ?? 'tr'; // Default olarak 'tr' döndür
    } catch (e) {
      print("Dil alma hatası: $e");
      return 'en'; // Hata durumunda default dil
    }
  }

  // Alternatif: Auth state değişikliklerini dinlemek için
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Manuel session refresh
  Future<void> refreshSession() async {
    try {
      await _supabase.auth.refreshSession();
      print("Session yenilendi");
    } catch (e) {
      print("Session yenileme hatası: $e");
    }
  }

  // Dil güncelleme sonrası callback ile bildirim
  Future<void> updateLanguageWithCallback(
    String newLanguage,
    Function(String?)? onSuccess,
  ) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        print("Kullanıcı oturum açmamış");
        return;
      }

      final currentMetadata = Map<String, dynamic>.from(
        user.userMetadata ?? {},
      );
      currentMetadata['preferred_language'] = newLanguage;

      final response = await _supabase.auth.updateUser(
        UserAttributes(data: currentMetadata),
      );

      if (response.user != null) {
        await _supabase.auth.refreshSession();

        // Callback ile güncel dili döndür
        if (onSuccess != null) {
          onSuccess(newLanguage);
        }

        print("Dil başarıyla güncellendi: $newLanguage");
      } else {
        print("Dil güncellenirken hata oluştu");
      }
    } catch (e) {
      print("Dil güncelleme hatası: $e");
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'https://just0lga.github.io/atakan-kara-port/',
      );
      print("Şifre sıfırlama maili gönderildi: $email");
    } catch (e) {
      print("Forgot password hatası: $e");
      rethrow;
    }
  }
}
