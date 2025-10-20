import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  const AppText({
    super.key,
    required this.text,
    this.textFontSize = 14,
    this.textFontWeight = FontWeight.w400,
    this.textColor = Colors.white,
    this.textHeight = 1,
    this.textAlign,
    this.overflow,
  });

  final String text;
  final double textFontSize;
  final FontWeight textFontWeight;
  final Color textColor;
  final double? textHeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: GoogleFonts.poppins(
        color: textColor,
        fontSize: textFontSize,
        fontWeight: textFontWeight,
        height: textHeight,
      ),
    );
  }
}
