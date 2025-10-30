import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/helpers/auth_gate.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/data/model/services/user_service.dart';
import 'package:near_voice/presentation/pages/profile_edit_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  final List<String> interests = [
    "Futbol",
    "Kitap Okuma",
    "PC Oyunları",
    "Basketbol",
    "Gezme",
  ];

  @override
  void initState() {
    super.initState();
    loadUserData();
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: GradientBackground(
        linearGradient: AppColor.backgroundGradient,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 Header
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
                                child: Icon(
                                  Icons.home,
                                  color: AppColor.white60,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              text: "Profil Bilgileri",
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

              // 🟣 Body
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: "Fotoğraflarım",
                              textColor: AppColor.white80,
                              textFontSize: width * 0.035,
                              textHeight: 1,
                            ),
                            EditButton(onTap: () {}),
                          ],
                        ),

                        SizedBox(height: height * 0.01),

                        Container(
                          width: width,
                          height: width * 0.3,
                          padding: EdgeInsets.symmetric(
                            vertical: width * 0.03,
                            horizontal: width * 0.03,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.white5,
                            border: Border.all(color: AppColor.white10),
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width * 0.27,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    width * 0.02,
                                  ),
                                  border: Border.all(color: AppColor.white10),
                                ),
                              ),
                              Container(
                                width: width * 0.27,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    width * 0.02,
                                  ),
                                  border: Border.all(color: AppColor.white10),
                                ),
                              ),
                              Container(
                                width: width * 0.27,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    width * 0.02,
                                  ),
                                  border: Border.all(color: AppColor.white10),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: height * 0.025),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: "Kişisel Bilgilerim",
                              textColor: AppColor.white80,
                              textFontSize: width * 0.035,
                              textHeight: 1,
                            ),
                            EditButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileEditPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: height * 0.01),

                        Container(
                          width: width,
                          padding: EdgeInsets.symmetric(
                            vertical: width * 0.03,
                            horizontal: width * 0.03,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.white5,
                            border: Border.all(color: AppColor.white10),
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProfileInfoRow(
                                title: "E-posta ",
                                subtitle: "${userData?['email'] ?? '-'}",
                                iconData: Icons.mail_outline_outlined,
                              ),
                              ProfileInfoRow(
                                title: "Kullanıcı Adı ",
                                subtitle: "${userData?['user_name'] ?? '-'}",
                                iconData: Icons.person_outline,
                              ),
                              ProfileInfoRow(
                                title: "Cinsiyet ",
                                subtitle: "${userData?['gender'] ?? '-'}",
                                iconData: Icons.man,
                              ),
                              ProfileInfoRow(
                                title: "Doğum Tarihi ",
                                subtitle: "${userData?['birth_date'] ?? '-'}",
                                iconData: Icons.date_range,
                              ),
                              /*
                              ProfileInfoRow(
                                title: "Latitude ",
                                subtitle: "${userData?['latitude'] ?? '-'}",
                                iconData: Icons.one_x_mobiledata,
                              ),
                              ProfileInfoRow(
                                title: "Longitude ",
                                subtitle: "${userData?['longitude'] ?? '-'}",
                                iconData: Icons.one_x_mobiledata,
                              ),*/
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.025),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: "Hakkımda",
                              textColor: AppColor.white80,
                              textFontSize: width * 0.035,
                              textHeight: 1,
                            ),
                            EditButton(onTap: () {}),
                          ],
                        ),

                        SizedBox(height: height * 0.01),

                        Container(
                          width: width,
                          padding: EdgeInsets.symmetric(
                            vertical: width * 0.03,
                            horizontal: width * 0.03,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.white5,
                            border: Border.all(color: AppColor.white10),
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text:
                                    "lsIjoiYmVyIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImdlbmRlciI6IkthZMSxbiIsInBob25lX3ZlcmlmaWVkIjpmYWxzZSwicHJlZmVycmVkX2xhbmd1YWdlIjoidHIiLCJzdWIiOiJjMzAyODY4MS0w",
                                textHeight: 1.5,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.025),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: "İlgili Alanlarım",
                              textColor: AppColor.white80,
                              textFontSize: width * 0.035,
                              textHeight: 1,
                            ),
                            EditButton(onTap: () {}),
                          ],
                        ),

                        SizedBox(height: height * 0.01),

                        Container(
                          width: width,
                          padding: EdgeInsets.symmetric(
                            vertical: width * 0.03,
                            horizontal: width * 0.03,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.white5,
                            border: Border.all(color: AppColor.white10),
                            borderRadius: BorderRadius.circular(width * 0.03),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [InterestsSection(interests: interests)],
                          ),
                        ),

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
      ),
    );
  }
}

class InterestsSection extends StatelessWidget {
  final List<String> interests;

  const InterestsSection({super.key, required this.interests});

  @override
  Widget build(BuildContext context) {
    if (interests.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: AppColor.logoGradient,
        ),
        child: const Center(
          child: Text(
            "İlgili alan bilgisi yok",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }

    // 🔸 Listeyi 3’lü gruplara böl
    List<List<String>> grouped = [];
    for (var i = 0; i < interests.length; i += 3) {
      grouped.add(
        interests.sublist(
          i,
          i + 3 > interests.length ? interests.length : i + 3,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: grouped.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: row.map((item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: AppColor.hoverGradient,
                    ),
                    child: AppText(text: item, textFontWeight: FontWeight.w500),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  const ProfileInfoRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconData,
  });

  final String title;
  final String subtitle;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
        ],
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  const EditButton({super.key, required this.onTap});

  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(width * 0.02),
        decoration: BoxDecoration(
          color: AppColor.white5,
          border: Border.all(color: AppColor.white10),
          borderRadius: BorderRadius.circular(width * 0.03),
        ),
        child: AppText(
          text: "Düzenle",
          textColor: AppColor.white80,
          textFontSize: width * 0.035,
          textHeight: 1,
        ),
      ),
    );
  }
}
