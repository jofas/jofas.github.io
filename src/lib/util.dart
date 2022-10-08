import 'package:flutter/material.dart';

class Spacer extends StatelessWidget {
  static final Spacer headlineSpace = Spacer(height: 30);
  static final Spacer paragraphSpace = Spacer(height: 40);
  static final Spacer tileSpace = Spacer(width: 30);

  final double width;
  final double height;

  Spacer({this.width: 0, this.height: 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}

class GradientIcon extends StatelessWidget {
  GradientIcon(
    this.icon, {
    required this.size,
    required this.gradient,
  });

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size + 1,
        height: size + 1,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}
