import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/widgets/app_text.dart';
import 'package:near_voice/core/helpers/auth_service.dart';
import 'package:near_voice/core/widgets/back_button_and_right_button.dart';
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
        child: Column(
          children: [
            BackButtonAndRightButton(),
            SizedBox(height: height * 0.10),
            Image.asset(
              "assets/near_voice_logo_purple2.png",
              height: height * 0.1,
            ),

            SizedBox(height: height * 0.10),

            // Email
            MyTextField(label: "Email", controller: _emailController),

            SizedBox(height: height * 0.01),

            // Send Reset Link button
            isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : SignButton(
                    buttonWidget: AppText(
                      text: "Send Reset Link",

                      textColor: Colors.white,
                      textFontSize: width * 0.05,
                      textFontWeight: FontWeight.w500,
                    ),
                    onTap: sendResetLink,
                    buttonColor: AppColor().mainColor,
                  ),
            Expanded(child: SizedBox()),
            AppText(
              text:
                  "You will take an e-mail about changing password from nearVoice@gmail.com",
              textAlign: TextAlign.center,
              textHeight: 1.3,
              textFontSize: width * 0.028,
            ),
          ],
        ),
      ),
    );
  }
}
