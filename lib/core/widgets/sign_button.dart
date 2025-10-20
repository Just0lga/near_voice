import 'package:flutter/material.dart';

class SignButton extends StatelessWidget {
  const SignButton({
    super.key,
    required this.buttonWidget,
    required this.onTap,
    required this.buttonColor,
  });

  final Widget buttonWidget;
  final GestureTapCallback onTap;
  final Color buttonColor;

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
          color: buttonColor,
          borderRadius: BorderRadius.circular(width * 0.04),
        ),
        child: buttonWidget,
      ),
    );
  }
}
