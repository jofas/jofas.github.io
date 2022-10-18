import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:url_launcher/url_launcher.dart';

import 'colors.dart';

void openLink(String url) {
  launchUrl(
    Uri.parse(url),
    webOnlyWindowName: "_blank",
  );
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

class Section extends StatelessWidget {
  final List<Widget> children;
  final double width;
  final List<Color> colors;
  final EdgeInsets padding;

  Section({
    required this.children,
    required this.width,
    required this.colors,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, -1),
          end: Alignment(0, 1),
          colors: colors,
        ),
      ),
      child: Center(
        child: Container(
          width: width,
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
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
  final TextStyle? style;

  Tile({
    required this.icon,
    required this.title,
    required this.content,
    this.titleUrl,
    this.style,
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
        style: textStyle.copyWith(
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? Theme.of(context).textTheme.bodyText2!;

    return Row(
      children: <Widget>[
        Icon(icon, color: textStyle.color),
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

class Link extends StatelessWidget {
  final String text;
  final String url;
  final TextStyle style;
  final TextAlign? textAlign;

  Link({
    required this.text,
    required this.url,
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
            style: style,
          ),
        ],
      ),
      textAlign: textAlign,
    );
  }
}

class InlineLink extends TextSpan {
  InlineLink({
    required String text,
    required String url,
    required TextStyle style,
  }) : super(
          text: text,
          mouseCursor: SystemMouseCursors.click,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              openLink(url);
            },
          style: style.copyWith(
            decoration: TextDecoration.underline,
          ),
        );
}
