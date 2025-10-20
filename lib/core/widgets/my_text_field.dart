import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';

class MyTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;

  const MyTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.emailAddress,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscure,
      cursorColor: AppColor().mainColor,
      cursorHeight: width * 0.056,
      cursorWidth: width * 0.005,
      autofocus: false,
      maxLines: 1,
      textInputAction: TextInputAction.next,
      style: TextStyle(
        fontFamily: "AnekLatin",
        color: AppColor().mainColor,
        fontSize: width * 0.037,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(
          fontFamily: "AnekLatin",
          color: AppColor().mainColor,
          fontSize: width * 0.037,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: width * 0.037,
          vertical: width * 0.034,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(width * 0.04),
          borderSide: BorderSide(color: AppColor().mainColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(width * 0.012),
          borderSide: BorderSide(color: AppColor().mainColor),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: AppColor().mainColor,
                  size: width * 0.056,
                ),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : null,
      ),
    );
  }
}
