import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/Env.dart';
import 'package:near_voice/core/helpers/auth_gate.dart';
import 'package:near_voice/presentation/pages/login_page.dart';
import 'package:near_voice/presentation/pages/settings_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase'i başlat
  await Supabase.initialize(url: Env.url, anonKey: Env.anonKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Near Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthGate(),
    );
  }
}
