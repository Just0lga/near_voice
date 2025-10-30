import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/widgets/app_text.dart';

class SignButton extends StatelessWidget {
  const SignButton({super.key, required this.text, required this.onTap});

  final String text;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height * 0.064,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width * 0.04),
          gradient: AppColor.logoGradient,
        ),
        child: AppText(
          text: text,
          textFontSize: width * 0.04,
          textFontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
