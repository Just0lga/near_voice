import 'package:flutter/material.dart';
import 'package:near_voice/core/constants/app_color.dart';

class BackButtonAndRightButton extends StatefulWidget {
  const BackButtonAndRightButton({super.key, this.button});
  final Widget? button;

  @override
  State<BackButtonAndRightButton> createState() =>
      _BackButtonAndRightButtonState();
}

class _BackButtonAndRightButtonState extends State<BackButtonAndRightButton> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
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
        widget.button ?? SizedBox(),
      ],
    );
  }
}
