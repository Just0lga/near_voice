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
      cursorColor: AppColor.white20,
      cursorHeight: width * 0.056,
      cursorWidth: width * 0.005,
      autofocus: false,
      maxLines: 1,
      textInputAction: TextInputAction.next,
      style: TextStyle(
        fontFamily: "AnekLatin",
        color: AppColor.white60,
        fontSize: width * 0.037,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(
          fontFamily: "AnekLatin",
          color: AppColor.white60,
          fontSize: width * 0.037,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: width * 0.02,
          vertical: width * 0.03,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.white20, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.white40, width: 1),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: AppColor.white60,
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
