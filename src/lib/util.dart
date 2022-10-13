import 'package:flutter/material.dart';

class Spacer extends StatelessWidget {
  static final Spacer headlineSpace = Spacer(height: 30);
  static final Spacer paragraphSpace = Spacer(height: 40);
  static final Spacer tileSpace = Spacer(width: 10);

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

class JumpAnimation extends StatefulWidget {
  final Widget child;

  JumpAnimation({required this.child, super.key});

  @override
  State<JumpAnimation> createState() => _JumpAnimationState();
}

class _JumpAnimationState extends State<JumpAnimation>
    with TickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<Offset> animation;

  @override
  void initState() {
    controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(
        reverse: true,
      );

    animation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -0.2),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: widget.child,
    );
  }
}
