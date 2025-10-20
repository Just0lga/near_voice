import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final Alignment begin;
  final Alignment end;
  final List<double> stops;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors = const [Colors.white, Color.fromARGB(255, 90, 40, 120)],
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.stops = const [0.0, 1.0],
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: width * 0.02,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors,
          stops: stops,
        ),
      ),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                height - MediaQuery.of(context).padding.top - kToolbarHeight,
          ),
          child: child,
        ),
      ),
    );
  }
}
