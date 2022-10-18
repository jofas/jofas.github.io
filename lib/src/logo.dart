import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:vector_math/vector_math.dart' hide Colors;

class Logo extends StatelessWidget {
  final Color color;

  Logo({this.color: Colors.white});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewport) {
        return CustomPaint(
          painter: LogoPainter(color: color),
          size: Size(viewport.maxWidth, viewport.maxHeight),
        );
      },
    );
  }
}

class LogoPainter extends CustomPainter {
  late final Paint strokeColor;

  LogoPainter({Color color: Colors.white}) {
    strokeColor = Paint()..color = color;
  }

  @override
  void paint(Canvas c, Size s) {
    double w = s.width;
    double h = s.height;

    double woffset = 0;
    double hoffset = 0;

    if (11 / 15 * w > h) {
      woffset = (w - 15 / 11 * h) / 2;
      w = 15 / 11 * h;
    } else {
      hoffset = (h - 11 / 15 * w) / 2;
      h = 11 / 15 * w;
    }

    final double wunit = w / 15;
    final double hunit = h / 11;

    final double r = hunit * 0.75;

    final p1 = Vector2(2 * wunit + woffset, 2 * hunit + hoffset);
    final p2 = Vector2(6 * wunit + woffset, 2 * hunit + hoffset);

    draw_short(c, r, p1, p2);

    final p3 = Vector2(2 * wunit + woffset, 9 * hunit + hoffset);
    final p4 = Vector2(6 * wunit + woffset, 9 * hunit + hoffset);
    final p5 = Vector2(6 * wunit + woffset, 5 * hunit + hoffset);

    draw_long(c, r, p3, p4, p5);

    final p6 = Vector2(13 * wunit + woffset, 2 * hunit + hoffset);
    final p7 = Vector2(9 * wunit + woffset, 2 * hunit + hoffset);

    draw_short(c, r, p6, p7);

    final p8 = Vector2(13 * wunit + woffset, 5 * hunit + hoffset);
    final p9 = Vector2(9 * wunit + woffset, 5 * hunit + hoffset);
    final p10 = Vector2(9 * wunit + woffset, 9 * hunit + hoffset);

    draw_long(c, r, p8, p9, p10);
  }

  void draw_short(Canvas c, double r, Vector2 p1, Vector2 p2) {
    c.drawPath(line(p1, p2, magnitude: r), strokeColor);
  }

  void draw_long(
    Canvas c,
    double r,
    Vector2 p1,
    Vector2 p2,
    Vector2 p3,
  ) {
    c.drawPath(line(p1, p2, magnitude: r), strokeColor);
    c.drawPath(line(p2, p3, magnitude: r), strokeColor);
  }

  Path line(
    Vector2 p1,
    Vector2 p2, {
    double magnitude: 1,
  }) {
    final direction = p2 - p1;

    late Vector2 perpendicular;

    if (direction.y == 0) {
      perpendicular = Vector2(0, -1);
    } else {
      perpendicular = Vector2(1, -direction.x / direction.y);
    }

    perpendicular = perpendicular.normalized() * magnitude;

    final path = Path();

    final p1start = p1 - perpendicular;
    final p1end = p1 + perpendicular;

    final p2start = p2 - perpendicular;
    final p2end = p2 + perpendicular;

    path.moveTo(p1start.x, p1start.y);

    path.lineTo(p2start.x, p2start.y);

    path.arcToPoint(
      Offset(p2end.x, p2end.y),
      radius: Radius.circular(magnitude),
      clockwise: p1.x > p2.x || p1.y > p2.y,
    );

    path.lineTo(p1end.x, p1end.y);

    path.arcToPoint(
      Offset(p1start.x, p1start.y),
      radius: Radius.circular(magnitude),
      clockwise: p1.x > p2.x || p1.y > p2.y,
    );

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
