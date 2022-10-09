import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:vector_math/vector_math.dart' hide Colors;

import 'colors.dart';

class Logo extends StatefulWidget {
  final Size size;

  Logo(this.size, {super.key});

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> with TickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat(
        reverse: true,
      );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LogoAnimation(size: widget.size, controller: controller);
  }
}

class LogoAnimation extends AnimatedWidget {
  final Size size;

  LogoAnimation({
    super.key,
    required this.size,
    required Animation<double> controller,
  }) : super(listenable: controller);

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LogoPainter(_progress.value),
      size: size,
      willChange: true,
    );
  }
}

extension Normalize on double {
  double normalize({double min: 0, double max: 1}) {
    return (this - min) / (max - min);
  }
}

extension AsOffset on Vector2 {
  Offset asOffset() {
    return Offset(this.x, this.y);
  }
}

class LogoPainter extends CustomPainter {
  final white = Paint()..color = Colors.white;

  final double state;

  LogoPainter(this.state);

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

    animate_short(c, r, p1, p2);

    final p3 = Vector2(2 * wunit + woffset, 9 * hunit + hoffset);
    final p4 = Vector2(6 * wunit + woffset, 9 * hunit + hoffset);
    final p5 = Vector2(6 * wunit + woffset, 5 * hunit + hoffset);

    animate_long(c, r, p3, p4, p5);

    final p6 = Vector2(13 * wunit + woffset, 2 * hunit + hoffset);
    final p7 = Vector2(9 * wunit + woffset, 2 * hunit + hoffset);

    animate_short(c, r, p6, p7);

    final p8 = Vector2(13 * wunit + woffset, 5 * hunit + hoffset);
    final p9 = Vector2(9 * wunit + woffset, 5 * hunit + hoffset);
    final p10 = Vector2(9 * wunit + woffset, 9 * hunit + hoffset);

    animate_long(c, r, p8, p9, p10);
  }

  Paint circleColor(Vector2 center, double r) {
    return Paint()
      ..shader = ui.Gradient.linear(
        Offset(center.x - r, center.y - r),
        Offset(center.x + r, center.y + r),
        [
          CustomColors.yellow[300]!,
          CustomColors.red[500]!,
        ],
      );
  }

  void animate_short(Canvas c, double r, Vector2 p1, Vector2 p2) {
    if (state <= 0.05) {
      // pause at the beginning
    }
    if (state <= 0.1) {
      // let circle fade in

      double factor = state.normalize(min: 0.05, max: 0.1);
      factor = Curves.easeIn.transform(factor.clamp(0, 1));

      c.drawCircle(
        p1.asOffset(),
        r * factor,
        circleColor(
          p1,
          r * factor,
        ),
      );
    } else if (state <= 0.5) {
      // draw first line

      double factor = state.normalize(min: 0.1, max: 0.5);
      factor = Curves.easeIn.transform(factor.clamp(0, 1));

      final pos = p1 + (p2 - p1) * factor;

      c.drawPath(line(p1, pos, magnitude: r), white);

      c.drawCircle(
        pos.asOffset(),
        r,
        circleColor(
          pos,
          r,
        ),
      );
    } else if (state <= 0.55) {
      // let circle fade out

      double factor = state.normalize(min: 0.5, max: 0.55);
      factor = Curves.easeOut.transform(factor.clamp(0, 1));

      c.drawPath(line(p1, p2, magnitude: r), white);

      c.drawCircle(
        p2.asOffset(),
        r * (1 - factor),
        circleColor(
          p2,
          r * (1 - factor),
        ),
      );
    } else {
      // pause at the end

      c.drawPath(line(p1, p2, magnitude: r), white);
    }
  }

  void animate_long(
    Canvas c,
    double r,
    Vector2 p1,
    Vector2 p2,
    Vector2 p3,
  ) {
    if (state <= 0.05) {
      // pause at the beginning
    }
    if (state <= 0.1) {
      // let circle fade in

      double factor = state.normalize(min: 0.05, max: 0.1);
      factor = Curves.easeIn.transform(factor.clamp(0, 1));

      c.drawCircle(
        p1.asOffset(),
        r * factor,
        circleColor(
          p1,
          r * factor,
        ),
      );
    } else if (state <= 0.3) {
      // draw first line

      double factor = state.normalize(min: 0.1, max: 0.3);
      factor = Curves.easeIn.transform(factor.clamp(0, 1));

      final pos = p1 + (p2 - p1) * factor;

      c.drawPath(line(p1, pos, magnitude: r), white);

      c.drawCircle(
        pos.asOffset(),
        r,
        circleColor(
          pos,
          r,
        ),
      );
    } else if (state <= 0.5) {
      // draw second line

      double factor = state.normalize(min: 0.3, max: 0.5);
      factor = Curves.easeOut.transform(factor.clamp(0, 1));

      final pos = p2 + (p3 - p2) * factor;

      c.drawPath(line(p1, p2, magnitude: r), white);
      c.drawPath(line(p2, pos, magnitude: r), white);

      c.drawCircle(
        pos.asOffset(),
        r,
        circleColor(
          pos,
          r,
        ),
      );
    } else if (state <= 0.55) {
      // let circle fade out

      double factor = state.normalize(min: 0.5, max: 0.55);
      factor = Curves.easeOut.transform(factor.clamp(0, 1));

      c.drawPath(line(p1, p2, magnitude: r), white);
      c.drawPath(line(p2, p3, magnitude: r), white);

      c.drawCircle(
        p3.asOffset(),
        r * (1 - factor),
        circleColor(
          p3,
          r * (1 - factor),
        ),
      );
    } else {
      // pause at the end

      c.drawPath(line(p1, p2, magnitude: r), white);
      c.drawPath(line(p2, p3, magnitude: r), white);
    }
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
  bool shouldRepaint(LogoPainter old) => old.state != state;
}
