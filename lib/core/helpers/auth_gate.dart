import 'package:flutter/material.dart';
import 'package:near_voice/core/helpers/auth_service.dart';
import 'package:near_voice/presentation/pages/login_page.dart';
import 'package:near_voice/presentation/pages/main_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    final String token = authService.getAuth() ?? "Boş";
    print("Auth Gate Token: $token");
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Check
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          // ✅ Login
          return const MainPage();
        } else {
          // ❌ Login
          return const LoginPage();
        }
      },
    );
  }
}
