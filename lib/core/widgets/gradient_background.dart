import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final LinearGradient linearGradient;

  const GradientBackground({
    super.key,
    required this.child,
    required this.linearGradient,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,

      decoration: BoxDecoration(gradient: linearGradient),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              height - MediaQuery.of(context).padding.top - kToolbarHeight,
        ),
        child: child,
      ),
    );
  }
}
