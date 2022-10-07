import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vector_math/vector_math.dart' hide Colors;

class OvalClipper extends CustomClipper<Path> {
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

  @override
  Path getClip(Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );

    final path = Path();

    path.addOval(rect);

    path.close();

    return path;
  }
}

abstract class SmoothClipper extends CustomClipper<Path> {
  final List<Vector2> points;
  final double smoothness;

  SmoothClipper({
    required this.points,
    required this.smoothness,
  }) : super();

  /// See [this link](http://scaledinnovation.com/analytics/splines/aboutSplines.html)
  /// for a detailed explanation of the math.
  ///
  List<_ControlPoints> _computeControlPoints() {
    final cps = List<_ControlPoints>.generate(
      points.length,
      (_) => _ControlPoints(),
    );

    for (int i = 0; i < points.length; i++) {
      final p0 = points[i % points.length];
      final p1 = points[(i + 1) % points.length];
      final p2 = points[(i + 2) % points.length];

      final d01 =
          math.sqrt(math.pow(p1.x - p0.x, 2) + math.pow(p1.y - p0.y, 2));

      final d12 =
          math.sqrt(math.pow(p2.x - p1.x, 2) + math.pow(p2.y - p1.y, 2));

      final fa = smoothness * d01 / (d01 + d12);
      final fb = smoothness * d12 / (d01 + d12);

      cps[i % cps.length].b = p1 - (p2 - p0) * fa;
      cps[(i + 1) % cps.length].a = p1 + (p2 - p0) * fb;
    }

    return cps;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class SmoothShapeClipper extends SmoothClipper {
  SmoothShapeClipper({
    required super.points,
    super.smoothness: 0.5,
  }) : super();

  @override
  Path getClip(Size size) {
    final cps = _computeControlPoints();

    final path = Path();

    path.moveTo(points[0].x * size.width, points[0].y * size.height);

    for (int i = 0; i < points.length; i++) {
      path.cubicTo(
        cps[i].a!.x * size.width,
        cps[i].a!.y * size.height,
        cps[i].b!.x * size.width,
        cps[i].b!.y * size.height,
        points[(i + 1) % points.length].x * size.width,
        points[(i + 1) % points.length].y * size.height,
      );
    }

    path.close();

    return path;
  }
}

class SmoothCurveClipper extends SmoothClipper {
  SmoothCurveClipper({
    required super.points,
    super.smoothness: 0.5,
  }) : super();

  @override
  Path getClip(Size size) {
    final cps = _computeControlPoints();

    final path = Path();

    path.moveTo(points[0].x * size.width, points[0].y * size.height);

    for (int i = 0; i < points.length - 1; i++) {
      path.cubicTo(
        cps[i].a!.x * size.width,
        cps[i].a!.y * size.height,
        cps[i].b!.x * size.width,
        cps[i].b!.y * size.height,
        points[i + 1].x * size.width,
        points[i + 1].y * size.height,
      );
    }

    path.lineTo(points[points.length - 1].x * size.width, size.height);
    path.lineTo(points[0].x * size.width, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _ControlPoints {
  Vector2? a;
  Vector2? b;

  @override
  String toString() {
    return "(a: $a b: $b)";
  }
}
