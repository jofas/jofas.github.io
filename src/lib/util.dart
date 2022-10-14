import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'colors.dart';

enum ScreenSize {
  sm,
  md,
  lg,
  // xl, 2xl currently not used
}

ScreenSize screenSizeFromViewport(BoxConstraints viewport) {
  final minScreenSize = math.min(
    viewport.maxWidth,
    viewport.maxHeight,
  );

  if (minScreenSize <= 640) {
    return ScreenSize.sm;
  } else if (minScreenSize <= 768) {
    return ScreenSize.md;
  } else {
    return ScreenSize.lg;
  }
}

class Spacer extends StatelessWidget {
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

class SingleChildPageContent extends StatelessWidget {
  final double width, height;
  final EdgeInsets padding;
  final Widget child;

  SingleChildPageContent({
    required this.width,
    required this.height,
    required this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: width,
          maxHeight: height,
        ),
        child: Padding(
          padding: padding,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}

class PageContent extends StatelessWidget {
  final double width, height;
  final EdgeInsets padding;
  final List<Widget> children;
  final Widget? footer;

  PageContent({
    required this.width,
    required this.height,
    required this.padding,
    required this.children,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: width,
          maxHeight: height,
        ),
        child: Padding(
          padding: padding,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: children,
                  ),
                ),
              ),
              footer == null ? Container() : footer!,
            ],
          ),
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  final String? titleUrl;
  final double? linkHeight;

  Tile({
    required this.icon,
    required this.title,
    required this.content,
    this.linkHeight,
    this.titleUrl,
  });

  InlineSpan _titleWidget(TextStyle textStyle) {
    if (titleUrl == null) {
      return TextSpan(
        text: title,
        style: textStyle.copyWith(
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return InlineLink(
        text: title,
        url: titleUrl!,
        height: linkHeight!,
        style: textStyle.copyWith(
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2!;

    return Row(
      children: <Widget>[
        Icon(icon),
        Spacer.tileSpace,
        Expanded(
          child: Text.rich(
            TextSpan(children: <InlineSpan>[
              _titleWidget(textStyle),
              TextSpan(
                text: " $content",
                style: textStyle,
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class OpenNavbarButton extends StatelessWidget {
  final double size;

  OpenNavbarButton({required this.size});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Icon(
        Icons.menu,
        color: Colors.white,
        size: size,
      ),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}

class NavButton extends StatefulWidget {
  final String text;
  final int page;
  final PageController controller;

  NavButton({
    required this.text,
    required this.page,
    required this.controller,
  });

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  late final void Function() _listener;

  bool isActive = false;

  @override
  void initState() {
    super.initState();

    _listener = () {
      _setState();
    };

    widget.controller.addListener(_listener);

    _setState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);

    super.dispose();
  }

  void _setState() {
    setState(() {
      isActive = widget.controller.page!.round() as int == widget.page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets?>(
          EdgeInsets.only(top: 20),
        ),
        foregroundColor: MaterialStateProperty.all<Color?>(
          isActive ? Colors.white : null,
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle?>((
          Set<MaterialState> states,
        ) {
          final textStyle = Theme.of(context).textTheme.bodyText2!.copyWith(
                fontWeight: isActive ? FontWeight.bold : null,
              );

          if (states.contains(MaterialState.focused)) {
            return textStyle.copyWith(
              decoration: TextDecoration.underline,
            );
          }
          return textStyle;
        }),
      ),
      child: Text(widget.text),
      onPressed: () {
        if (!isActive) {
          Scaffold.of(context).closeDrawer();
          widget.controller.animateToPage(
            widget.page,
            duration: Duration(seconds: 1),
            curve: Curves.ease,
          );
        }
      },
    );
  }
}

class Link extends StatelessWidget {
  final String text;
  final String url;
  final double height;
  final TextStyle style;
  final TextAlign? textAlign;

  Link({
    required this.text,
    required this.url,
    required this.height,
    required this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          InlineLink(
            text: text,
            url: url,
            height: height,
            style: style,
          ),
        ],
      ),
      textAlign: textAlign,
    );
  }
}

class InlineLink extends WidgetSpan {
  InlineLink({
    required String text,
    required String url,
    required double height,
    required TextStyle style,
  }) : super(
          child: Container(
            height: height,
            child: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets?>(
                  EdgeInsets.all(0),
                ),
                textStyle: MaterialStateProperty.resolveWith<TextStyle?>((
                  Set<MaterialState> states,
                ) {
                  if (states.contains(MaterialState.focused)) {
                    return style.copyWith(
                      decoration: TextDecoration.underline,
                    );
                  }
                  return style;
                }),
              ),
              child: Text(text),
              onPressed: () {
                launchUrl(Uri.parse(url));
              },
            ),
          ),
        );
}

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
                  minHeight: widget.height,
                );
              },
            ),
          ),
        ),
        SizedBox(width: 15),
        Text(
          "${(currPos * (widget.pages - 1)).round() + 1}  /  ${widget.pages}",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        SizedBox(width: 5),
        _prevPageButton,
        _nextPageButton,
      ],
    );
  }
}
