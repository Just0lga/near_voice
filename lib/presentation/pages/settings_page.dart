import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/helpers/auth_service.dart';
import 'package:near_voice/core/widgets/back_button_and_right_button.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:near_voice/core/widgets/background_image.dart';
import 'package:near_voice/core/widgets/custom_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final authService = AuthService();
  void logout() async {
    await authService.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BackgroundImage(
        childWidget: Column(
          children: [
            CustomAppBar(title: "Ayarlar"),

            SettingsButton(icon: Icons.logout, text: 'Log Out', onTap: logout),
          ],
        ),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height * 0.08,
        padding: EdgeInsets.symmetric(
          vertical: height * 0.005,
          horizontal: width * 0.05,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(width * 0.05),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Color.fromARGB(255, 220, 166, 201),
              size: width * 0.060,
            ),
            SizedBox(width: width * 0.028),
            AppText(
              text: text,
              textFontWeight: FontWeight.w500,
              textFontSize: width * 0.056,
              textColor: Color.fromARGB(255, 220, 166, 201),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color.fromARGB(255, 220, 166, 201),
              size: width * 0.060,
            ),
          ],
        ),
      ),
    );
  }
}
