import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/helpers/auth_service.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/core/widgets/my_text_field.dart';
import 'package:near_voice/core/widgets/sign_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final authService = AuthService();

  final _emailController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    _emailController.text = "kucukascit@gmail.com";
    // TODO: implement initState
    super.initState();
  }

  void sendResetLink() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: AppText(text: "Please enter your email")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authService.sendPasswordResetEmail(email);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText(text: "Password reset link sent to your email"),
          ),
        );
        Navigator.pop(context); // ekranı kapat
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: AppText(text: "Error: $e")));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GradientBackground(
        linearGradient: AppColor.backgroundGradient,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),

          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: height * 0.04,
                  child: Row(
                    children: [
                      SizedBox(width: width * 0.02),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColor.white60,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: width * 0.25,
                  height: width * 0.25,
                  decoration: BoxDecoration(
                    gradient: AppColor.logoGradient,
                    borderRadius: BorderRadius.circular(width * 0.05),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: width * 0.15,
                  ),
                ),

                SizedBox(height: height * 0.03),

                AppText(
                  text: "Near Voice",
                  textFontWeight: FontWeight.w600,
                  textFontSize: width * 0.1,
                ),

                SizedBox(height: height * 0.08),

                // Email
                MyTextField(label: "Email", controller: _emailController),

                SizedBox(height: height * 0.03),

                // Send Reset Link button
                isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : SignButton(
                        text: "Şifre yenileme linki gönder",
                        onTap: sendResetLink,
                      ),
                Expanded(child: SizedBox()),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      text: "nearVoice@gmail.com ",
                      textFontWeight: FontWeight.w500,
                      textFontSize: width * 0.034,
                      textColor: AppColor.purple500,
                    ),
                    AppText(
                      text: " tarafından bir şifre",
                      textFontWeight: FontWeight.w600,
                      textFontSize: width * 0.034,
                      textColor: AppColor.white40,
                    ),
                  ],
                ),
                SizedBox(height: height * 0.005),
                AppText(
                  text: " değiştirme linki alacaksınız",
                  textFontWeight: FontWeight.w600,
                  textFontSize: width * 0.034,
                  textColor: AppColor.white40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
