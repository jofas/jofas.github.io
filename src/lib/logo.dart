import 'package:flutter/material.dart';

// TODO: stateful widget

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(seconds: 12),
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: 0,
        end: 1,
      ),
      builder: (BuildContext context, double value, _) {
        return CustomPaint(
          painter: LogoPainter(value),
          size: Size(300, 300),
          willChange: true,
        );
      },
    );
  }
}

class LogoPainter extends CustomPainter {
  final double state;

  LogoPainter(this.state);

  @override
  void paint(Canvas c, Size s) {
    final paint = Paint();
    paint.color = Colors.white;

    final pos = Offset(state * s.width, s.height / 2);
    print("pos: $pos");

    c.drawCircle(pos, 20, paint);
  }

  @override
  bool shouldRepaint(LogoPainter old) => true;
}
