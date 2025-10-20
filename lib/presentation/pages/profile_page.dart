import 'package:flutter/material.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/widgets/background_image.dart';
import 'package:near_voice/core/widgets/custom_app_bar.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.purple,
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(title: "Profile"),
              Container(
                padding: EdgeInsets.all(height * 0.01),
                width: width,
                height: height * 0.07,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(width * 0.05),
                ),
                child: Row(
                  children: [
                    Container(
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
                    SizedBox(width: width * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppText(
                              text: "Tolga Kaya",
                              textColor: Colors.black,
                              textFontWeight: FontWeight.w600,
                              textFontSize: width * 0.04,
                              textHeight: 1,
                            ),
                            SizedBox(width: width * 0.02),
                            AppText(
                              text: "23",
                              textColor: Colors.grey,
                              textFontWeight: FontWeight.w600,
                              textHeight: 1,
                              textFontSize: width * 0.04,
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.01),
                        Row(
                          children: [
                            AppText(
                              text: "@Justolga",
                              textColor: Colors.black,
                              textFontWeight: FontWeight.w300,
                              textHeight: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.location_on, color: Colors.black),
                          AppText(
                            text: "Adana, Turkey",
                            textColor: Colors.black,
                            textFontWeight: FontWeight.w300,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.01),
              Container(
                width: width,
                height: width * 1.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(width * 0.05),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(width * 0.05),
                  child: Image.asset("assets/profile.png", fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: height * 0.01),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.02,
                  horizontal: width * 0.05,
                ),
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.05),
                  color: Colors.white.withOpacity(0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: "Hi, I'm Tolga",
                          textColor: Colors.grey,
                          textFontSize: width * 0.03,
                          textFontWeight: FontWeight.w500,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: width * 0.05,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: width * 0.05,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    AppText(
                      text:
                          "A solid workout iscovering new music, play computer games, football etc.A solid workout iscovering new music, play computer games, football etc.A solid workout iscovering new music, play computer games, football etc.A solid workout iscovering new music, play computer games, football etc.",
                      textColor: Colors.black,
                      textFontSize: width * 0.04,
                      textFontWeight: FontWeight.w500,
                      textHeight: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
