import 'dart:ui';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/helpers/auth_service.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:near_voice/core/widgets/background_image.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/presentation/pages/discover_page.dart';
import 'package:near_voice/presentation/pages/privacy_policy_page.dart';
import 'package:near_voice/presentation/pages/profile_page.dart';
import 'package:near_voice/presentation/pages/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final authService = AuthService();

  bool isPressed = false; // Buton basılı mı?

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Get current user
    final currentEmail = authService.getCurrentUserEmail();
    final currentToken = authService.getAuth();
    print("Bearer $currentToken");

    return Scaffold(
      backgroundColor: Colors.red,
      body: GradientBackground(
        child: Column(
          children: [
            // Header
            Stack(
              children: [
                Container(
                  height: width * 0.1,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText(
                        text: "Hoşgeldiniz",
                        textFontSize: width * 0.07,
                        textFontWeight: FontWeight.w500,
                        textColor: AppColor().mainColor,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: height * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(width * 0.05),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(
                            width * 0.04,
                          ),
                          child: Image.asset("assets/profile.png"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: height * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    MainPageButton(
                      containerHeight: height * 0.2,
                      contaierColor: Color(0xFF6E3BAE),
                      text: "Yeni İnsanlar Keşfet",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscoverPage(),
                          ),
                        );
                        print("Glass Button tıklandı!");
                      },
                    ),
                    SizedBox(height: width * 0.04),
                    MainPageButton(
                      containerHeight: height * 0.4,
                      contaierColor: Color(0xFFB38BFA),
                      text: "boş",
                      onTap: () {},
                    ),
                    SizedBox(height: width * 0.04),
                    MainPageButton(
                      containerHeight: height * 0.1,
                      contaierColor: Color.fromARGB(255, 110, 77, 151),
                      text: "Ayarlar",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(),
                          ),
                        );
                        print("Glass Button tıklandı!");
                      },
                    ),
                  ],
                ),

                Column(
                  children: [
                    MainPageButton(
                      containerHeight: height * 0.1,
                      contaierColor: Color(0xFFD1A3FF),
                      text: "Profil",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ),
                        );
                        print("Glass Button tıklandı!");
                      },
                    ),
                    SizedBox(height: width * 0.04),
                    MainPageButton(
                      containerHeight: height * 0.3,
                      contaierColor: Color.fromARGB(255, 159, 104, 214),
                      text: "Sohbetlerim",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ),
                        );
                        print("Glass Button tıklandı!");
                      },
                    ),
                    SizedBox(height: width * 0.04),
                    MainPageButton(
                      containerHeight: height * 0.3,
                      contaierColor: Color.fromARGB(255, 108, 31, 202),
                      text: "Boş",
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
            Expanded(child: SizedBox()),

            SizedBox(height: height * 0.005),

            Center(
              child: Text(
                "© 2025 Justolga",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: width * 0.032,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPageButton extends StatelessWidget {
  const MainPageButton({
    super.key,
    required this.containerHeight,
    required this.contaierColor,
    required this.text,
    this.textColor = Colors.white,
    required this.onTap,
  });

  final double containerHeight;
  final Color contaierColor;
  final String text;
  final Color textColor;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width * 0.44,
        height: containerHeight,
        decoration: BoxDecoration(
          color: contaierColor,
          borderRadius: BorderRadius.circular(width * 0.02),
        ),
        alignment: Alignment.center,
        child: AppText(
          text: text,
          textColor: textColor,
          textFontWeight: FontWeight.w500,
          textFontSize: width * 0.05,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
