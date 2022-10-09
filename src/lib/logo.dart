import 'package:flutter/material.dart';

import 'package:vector_math/vector_math.dart' hide Colors;

class Logo extends StatefulWidget {
  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> with TickerProviderStateMixin {
  late final Animation<double> controller;

  @override
  void initState() {
    final c = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(
        reverse: true,
      );

    controller = CurvedAnimation(
      parent: c,
      curve: Curves.easeInOut,
    );
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

    c.drawPath(line(p1, p2, magnitude: r), white);
    c.drawPath(line(p2, p3, magnitude: r), white);

    late final circlePos;

    if (state <= 0.5) {
      circlePos = Offset(state * 2 * s.width, 0);
    } else {
      circlePos = Offset(s.width, ((state - 0.5) / 0.5) * s.height);
    }

    // TODO: draw paths according to simulation

    c.drawCircle(circlePos, r, black);
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
