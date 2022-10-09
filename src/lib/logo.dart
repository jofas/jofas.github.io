import 'package:flutter/material.dart';

import 'package:vector_math/vector_math.dart' hide Colors;

class Logo extends StatefulWidget {
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
    return LogoAnimation(controller: controller);
  }
}

class LogoAnimation extends AnimatedWidget {
  LogoAnimation({
    super.key,
    required Animation<double> controller,
  }) : super(listenable: controller);

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LogoPainter(_progress.value),
      size: Size(300, 300),
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
  final double state;

  LogoPainter(this.state);

  @override
  void paint(Canvas c, Size s) {
    final white = Paint()..color = Colors.white;
    final black = Paint()..color = Colors.black;

    final double r = 20;

    final p1 = Vector2(0, 0);
    final p2 = Vector2(s.width, 0);
    final p3 = Vector2(s.width, s.height);

    if (state <= 0.05) {
      // pause at the beginning
    }
    if (state <= 0.1) {
      // let circle fade in

      double factor = state.normalize(min: 0.05, max: 0.1);
      factor = Curves.easeIn.transform(factor);

      c.drawCircle(p1.asOffset(), r * factor, black);
    } else if (state <= 0.3) {
      // draw first line

      double factor = state.normalize(min: 0.1, max: 0.3);
      factor = Curves.easeIn.transform(factor);

      final pos = Vector2(factor * s.width, 0);

      c.drawPath(line(p1, pos, magnitude: r), white);

      c.drawCircle(Offset(pos.x, pos.y), r, black);
    } else if (state <= 0.5) {
      // draw second line

      double factor = state.normalize(min: 0.3, max: 0.5);
      factor = Curves.easeOut.transform(factor);

      final pos = Vector2(s.width, factor * s.height);

      c.drawPath(line(p1, p2, magnitude: r), white);
      c.drawPath(line(p2, pos, magnitude: r), white);

      c.drawCircle(pos.asOffset(), r, black);
    } else if (state <= 0.55) {
      // let circle fade out

      double factor = state.normalize(min: 0.5, max: 0.55);
      factor = Curves.easeOut.transform(factor);

      c.drawPath(line(p1, p2, magnitude: r), white);
      c.drawPath(line(p2, p3, magnitude: r), white);

      c.drawCircle(p3.asOffset(), r * (1 - factor), black);
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
      clockwise: false,
    );

    path.lineTo(p1end.x, p1end.y);

    path.arcToPoint(
      Offset(p1start.x, p1start.y),
      radius: Radius.circular(magnitude),
      clockwise: false,
    );

    return path;
  }

  @override
  bool shouldRepaint(LogoPainter old) => old.state != state;
}
