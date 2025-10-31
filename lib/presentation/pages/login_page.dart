import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/helpers/auth_service.dart';
import 'package:near_voice/core/widgets/gradient_background.dart';
import 'package:near_voice/presentation/pages/forgot_password_page.dart';
import 'package:near_voice/core/widgets/my_text_field.dart';
import 'package:near_voice/presentation/pages/register_page.dart';
import 'package:near_voice/core/widgets/sign_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    _emailController.text = "berfintugal@gmail.com";
    _passwordController.text = "zxcv1234";
    super.initState();
  }

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await authService.signInWithEmailAndPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: AppText(text: "Error: $e"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GradientBackground(
        linearGradient: AppColor.backgroundGradient,

        child: Padding(
          padding: EdgeInsets.only(
            top: height * 0.04,
            left: width * 0.03,
            right: width * 0.03,
          ),
          child: SafeArea(
            child: Column(
              children: [
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

                SizedBox(height: height * 0.015),

                AppText(
                  text: "Yaknındaki kayıp sesi bul",
                  textFontWeight: FontWeight.w300,
                  textFontSize: width * 0.036,
                  textColor: AppColor.white60,
                ),

                SizedBox(height: height * 0.03),

                MyTextField(label: "Email", controller: _emailController),

                SizedBox(height: height * 0.010),

                MyTextField(
                  label: "Password",
                  controller: _passwordController,
                  obscureText: true,
                ),

                SizedBox(height: height * 0.04),

                ForgotPasswordButton(),

                SizedBox(height: height * 0.04),

                SignButton(text: "Giriş Yap", onTap: login),

                SizedBox(height: height * 0.07),

                Or(),

                SizedBox(height: height * 0.07),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LoginPlatformButton(
                      onTap: () {},
                      text: 'Google',
                      imagePath: 'assets/google_logo.png',
                    ),

                    LoginPlatformButton(
                      onTap: () {},
                      text: 'Apple',
                      imagePath: 'assets/apple_logo.png',
                    ),
                  ],
                ),

                Expanded(child: SizedBox()),

                SignUpNavigateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Or extends StatelessWidget {
  const Or({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(color: AppColor.white20, width: width * 0.4, height: 1),
        AppText(text: "veya", textColor: AppColor.white40),
        Container(color: AppColor.white20, width: width * 0.4, height: 1),
      ],
    );
  }
}

class LoginPlatformButton extends StatelessWidget {
  const LoginPlatformButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.imagePath,
  });

  final GestureTapCallback onTap;
  final String text;
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width * 0.45,
        height: height * 0.064,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width * 0.04),
          color: Colors.transparent,
          border: Border.all(color: AppColor.white20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: width * 0.05),
            SizedBox(width: width * 0.02),
            AppText(
              text: text,
              textFontSize: width * 0.04,
              textFontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpNavigateButton extends StatelessWidget {
  const SignUpNavigateButton({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            );
          },
          child: Row(
            children: [
              AppText(
                text: "Hesabınız yok mu?",
                textFontWeight: FontWeight.w500,
                textFontSize: width * 0.034,
                textColor: AppColor.white40,
              ),
              AppText(
                text: " Kayıt Ol",
                textFontWeight: FontWeight.w600,
                textFontSize: width * 0.034,
                textColor: AppColor.purple500,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ForgotPasswordPage(),
              ),
            );
          },
          child: AppText(
            text: "Şifremi Unuttum?",
            textFontWeight: FontWeight.w500,
            textFontSize: width * 0.034,
            textColor: AppColor.purple500,
          ),
        ),
      ],
    );
  }
}
