import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';
import 'package:near_voice/core/widgets/app_text.dart';

class CustomAppBar extends StatefulWidget {
  CustomAppBar({super.key, required this.title});

  final String title;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: height * 0.02),
      child: Stack(
        children: [
          Container(
            height: width * 0.1,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText(
                  text: widget.title,
                  textFontSize: width * 0.07,
                  textFontWeight: FontWeight.w500,
                  textColor: AppColor().mainColor,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapUp: (_) => setState(() => _isPressed = false),
                onTapCancel: () => setState(() => _isPressed = false),
                child: CircleAvatar(
                  radius: width * 0.06,
                  backgroundColor: _isPressed
                      ? AppColor().mainColor.withOpacity(0.7)
                      : AppColor().mainColor.withOpacity(0.5),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8), // küçük sağa kaydırma
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: _isPressed
                          ? Colors.white.withOpacity(0.7)
                          : Colors.white,
                      size: width * 0.064,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
