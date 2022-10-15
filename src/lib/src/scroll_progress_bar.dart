import 'package:flutter/material.dart';

import 'colors.dart' show CustomColors;
import 'util.dart' show InverseTextStyle;

class ScrollProgressBar extends StatefulWidget {
  final PageController controller;
  final int pages;
  final double height, iconSize;

  ScrollProgressBar({
    super.key,
    required this.controller,
    required this.pages,
    required this.height,
    required this.iconSize,
  });

  @override
  State<ScrollProgressBar> createState() => _ScrollProgressBarState();
}

class _ScrollProgressBarState extends State<ScrollProgressBar> {
  double currPos = 0.0;
  double prevPos = 0.0;
  bool hasScrolled = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() {
        prevPos = currPos;
        currPos = widget.controller.page! / (widget.pages - 1);
        hasScrolled = true;
      });
    });
  }

  void _nextPage() {
    widget.controller.nextPage(
      duration: Duration(seconds: 1),
      curve: Curves.ease,
    );
  }

  void _prevPage() {
    widget.controller.previousPage(
      duration: Duration(seconds: 1),
      curve: Curves.ease,
    );
  }

  Widget get _prevPageButton {
    return TextButton(
      child: Icon(Icons.expand_less, size: widget.iconSize),
      onPressed: _prevPage,
    );
  }

  Widget get _nextPageButton {
    final button = TextButton(
      child: Icon(Icons.expand_more, size: widget.iconSize),
      onPressed: _nextPage,
    );

    if (hasScrolled) {
      return button;
    } else {
      return JumpAnimation(
        child: button,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = ((widget.controller.page ?? 0) - 0.015).ceil();
    final inverted = page % 2 == 1;

    return Row(
      children: <Widget>[
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 100),
              curve: Curves.linear,
              tween: Tween<double>(
                begin: prevPos,
                end: currPos,
              ),
              builder: (BuildContext context, double value, _) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: inverted ? Colors.black : Colors.white,
                  color: CustomColors.red[300],
                  minHeight: widget.height,
                );
              },
            ),
          ),
        ),
        SizedBox(width: 15),
        Text(
          "${(currPos * (widget.pages - 1)).round() + 1}  /  ${widget.pages}",
          style: inverted
              ? Theme.of(context).textTheme.labelMedium!.inverse()
              : Theme.of(context).textTheme.labelMedium,
        ),
        SizedBox(width: 5),
        _prevPageButton,
        _nextPageButton,
      ],
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
