import 'package:flutter/material.dart';

import 'colors.dart';

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

class ScrollProgressBar extends StatefulWidget {
  final PageController controller;
  final int pages;

  ScrollProgressBar({
    super.key,
    required this.controller,
    required this.pages,
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
    return IconButton(
      icon: const Icon(Icons.expand_less, size: 20),
      tooltip: "Page Up",
      splashRadius: 1,
      onPressed: _prevPage,
    );
  }

  Widget get _nextPageButton {
    final button = IconButton(
      icon: const Icon(Icons.expand_more, size: 20),
      tooltip: "Page Down",
      splashRadius: 1,
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
                  backgroundColor: Colors.white,
                  color: CustomColors.red[300],
                  minHeight: 10,
                );
              },
            ),
          ),
        ),
        SizedBox(width: 25),
        Text(
          "${(currPos * (widget.pages - 1)).round() + 1}  /  ${widget.pages}",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 12,
              ),
        ),
        SizedBox(width: 10),
        _prevPageButton,
        _nextPageButton,
      ],
    );
  }
}
