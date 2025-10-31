import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/helpers/auth_gate.dart';
import 'package:near_voice/core/helpers/auth_service.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/data/services/user_service.dart';
import 'package:near_voice/presentation/pages/edit_max_distance_page.dart';
import 'package:near_voice/presentation/pages/edit_range_of_age_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final authService = AuthService();
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void logout() async {
    await authService.signOut();
    Navigator.pop(context);
  }

  Future<void> loadUserData() async {
    final authUser = Supabase.instance.client.auth.currentUser;
    if (authUser == null) return;

    final details = await UserService().getCurrentUserDetails();

    setState(() {
      userData = {
        'email': authUser.email,
        ...?details,
        ...?authUser.userMetadata,
      };
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GradientBackground(
        linearGradient: AppColor.backgroundGradient,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟣 HEADER (padding'den etkilenmez)
            Container(
              width: width,
              decoration: BoxDecoration(
                color: AppColor.white5,
                border: Border(bottom: BorderSide(color: AppColor.white10)),
              ),
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                bottom: false, // altta fazladan boşluk olmasın
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: width * 0.03),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: width * 0.02),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AuthGate(),
                                ),
                              );
                            },
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.home, color: AppColor.white60),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            text: "Ayarlar",
                            textFontSize: width * 0.055,
                            textHeight: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 🟣 BODY (padding uygulanır)
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.02,
                  horizontal: width * 0.03,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Hesap",
                        textColor: AppColor.white80,
                        textFontSize: width * 0.035,
                        textHeight: 1,
                      ),

                      SizedBox(height: height * 0.015),

                      // Butonlar
                      SettingsButton(
                        iconData: Icons.person_2_outlined,
                        title: 'Profil',
                        subtitle: 'Profil bilgilerini güncelle',
                        onTap: () {},
                      ),

                      SettingsButton(
                        iconData: Icons.key,
                        title: 'Şifre',
                        subtitle: 'Şifre bilgilerini güncelle',
                        onTap: () {},
                      ),

                      SettingsButton(
                        iconData: Icons.privacy_tip_outlined,
                        title: 'Gizlilik',
                        subtitle: 'Gizlilik bilgilerini görüntüle',
                        onTap: () {},
                      ),

                      SizedBox(height: height * 0.03),

                      AppText(
                        text: "Tercihler",
                        textColor: AppColor.white80,
                        textFontSize: width * 0.035,
                        textHeight: 1,
                      ),

                      SizedBox(height: height * 0.015),

                      SettingsButton(
                        iconData: Icons.location_on_outlined,
                        title: 'Konum',
                        subtitle: 'Konum bilgilerini güncelle',
                        onTap: () {},
                      ),

                      SettingsButton(
                        iconData: Icons.person_2_outlined,
                        title: 'Aktif Hesap',
                        subtitle: 'Diğer insanlar konumunu görebilsin',
                        onTap: () {},
                      ),

                      SizedBox(height: height * 0.03),

                      AppText(
                        text: "Keşfet",
                        textColor: AppColor.white80,
                        textFontSize: width * 0.035,
                        textHeight: 1,
                      ),

                      SizedBox(height: height * 0.015),

                      SettingsButton(
                        iconData: Icons.location_on_outlined,
                        title: 'Uzaklık',
                        subtitle: userData?["max_distance"].toString() ?? "",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditMaxDistancePage(),
                            ),
                          );
                        },
                      ),

                      SettingsButton(
                        iconData: Icons.person_2_outlined,
                        title: 'Yaş Aralığı',
                        subtitle:
                            "${userData?["min_age"].toString()} - ${userData?["max_age"].toString()}",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditRangeOfAgePage(),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: height * 0.03),

                      AppText(
                        text: "Destek",
                        textColor: AppColor.white80,
                        textFontSize: width * 0.035,
                        textHeight: 1,
                      ),

                      SizedBox(height: height * 0.015),

                      SettingsButton(
                        iconData: Icons.live_help_outlined,
                        title: 'Yardım Merkezi',
                        subtitle: 'Yardım ve destek alın',
                        onTap: () {},
                      ),

                      SettingsButton(
                        iconData: Icons.privacy_tip_outlined,
                        title: 'Gizlilik Politikası',
                        subtitle: 'Politikalarımızı okuyunuz',
                        onTap: () {},
                      ),

                      SizedBox(height: height * 0.03),

                      AppText(
                        text: "Hesap Aktifitesi",
                        textColor: AppColor.white80,
                        textFontSize: width * 0.035,
                        textHeight: 1,
                      ),

                      SizedBox(height: height * 0.015),

                      SettingsLogOutButton(title: "Çıkış Yap", onTap: logout),

                      SizedBox(height: height * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            text: "Near Voice",
                            textColor: AppColor.white60,
                            textFontSize: width * 0.03,
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.03),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    required this.iconData,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData iconData;
  final String title;
  final String subtitle;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColor.white5,
          borderRadius: BorderRadius.circular(width * 0.03),
          border: Border.all(color: AppColor.white10),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: width * 0.05,
        ),
        margin: EdgeInsets.symmetric(vertical: height * 0.005),
        child: Row(
          children: [
            Container(
              height: width * 0.09,
              width: width * 0.09,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width * 0.03),
                color: AppColor.purple800,
              ),
              child: Icon(iconData, color: AppColor.purple400),
            ),
            SizedBox(width: width * 0.04),
            SizedBox(
              height: width * 0.08,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: title,
                    textFontWeight: FontWeight.w500,
                    textFontSize: width * 0.038,
                  ),
                  AppText(
                    text: subtitle,
                    textColor: AppColor.white60,
                    textFontSize: width * 0.03,
                  ),
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            Icon(Icons.arrow_forward_ios_rounded, color: AppColor.white60),
          ],
        ),
      ),
    );
  }
}

class SettingsLogOutButton extends StatelessWidget {
  const SettingsLogOutButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColor.white5,
          borderRadius: BorderRadius.circular(width * 0.03),
          border: Border.all(color: AppColor.white10),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: width * 0.05,
        ),
        margin: EdgeInsets.symmetric(vertical: height * 0.005),
        child: Row(
          children: [
            Container(
              height: width * 0.09,
              width: width * 0.09,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width * 0.03),
                color: Colors.red.withOpacity(0.4),
              ),
              child: Icon(
                Icons.logout,
                color: Color.fromARGB(255, 255, 100, 100),
              ),
            ),
            SizedBox(width: width * 0.04),
            AppText(
              text: title,
              textFontWeight: FontWeight.w500,
              textFontSize: width * 0.038,
              textColor: Color.fromARGB(255, 255, 100, 100),
            ),
            Expanded(child: SizedBox()),
            Icon(Icons.arrow_forward_ios_rounded, color: AppColor.white60),
          ],
        ),
      ),
    );
  }
}
