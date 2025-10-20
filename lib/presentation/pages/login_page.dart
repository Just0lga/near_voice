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
    _emailController.text = "tolgads0101@gmail.com";
    _passwordController.text = "1234zxcv";
    super.initState();
  }

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await authService.signInWithEmailAndPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: AppText(text: "Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            SizedBox(height: height * 0.10),
            Image.asset(
              "assets/near_voice_logo_purple2.png",
              height: height * 0.1,
            ),

            SizedBox(height: height * 0.08),

            MyTextField(label: "Email", controller: _emailController),

            SizedBox(height: height * 0.010),

            MyTextField(
              label: "Password",
              controller: _passwordController,
              obscureText: true,
            ),

            SizedBox(height: height * 0.020),

            ForgotPasswordButton(),

            SizedBox(height: height * 0.040),

            SignButton(
              buttonWidget: AppText(
                text: "Sign In",
                textFontSize: width * 0.05,
                textFontWeight: FontWeight.w500,
              ),
              onTap: login,
              buttonColor: AppColor().mainColor,
            ),
            SizedBox(height: height * 0.010),
            SignButton(
              buttonWidget: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: "Sign in with Google",
                          textColor: AppColor().mainColor,
                          textFontSize: width * 0.05,
                          textFontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(width * 0.034),
                          child: Image.asset("assets/google_logo.png"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: login,
              buttonColor: Colors.white,
            ),
            SizedBox(height: height * 0.010),
            SignButton(
              buttonWidget: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: "Sign in with Apple",
                          textColor: AppColor().mainColor,
                          textFontSize: width * 0.05,
                          textFontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.038,
                            vertical: width * 0.03,
                          ),
                          child: Image.asset("assets/apple_logo.png"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: login,
              buttonColor: Colors.white,
            ),

            Expanded(child: SizedBox()),

            SignUpNavigateButton(),
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
                text: "Don't have an account?",
                textFontWeight: FontWeight.w500,
                textFontSize: width * 0.034,
                textColor: Colors.white,
              ),
              AppText(
                text: " Sign Up",
                textFontWeight: FontWeight.w600,
                textFontSize: width * 0.034,
                textColor: Colors.white,
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
            text: "Forgot Password?",
            textFontWeight: FontWeight.w600,
            textFontSize: width * 0.034,
            textColor: AppColor().mainColor,
          ),
        ),
      ],
    );
  }
}
