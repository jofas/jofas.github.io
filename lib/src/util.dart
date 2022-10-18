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

class Page extends StatelessWidget {
  final Widget child;
  final List<Color> colors;

  Page({
    required this.child,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewport) {
        return Container(
          width: viewport.maxWidth,
          height: viewport.maxHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
            ),
          ),
          child: child,
        );
      },
    );
  }
}

class PageContent extends StatelessWidget {
  final double width;
  final EdgeInsets padding;
  final List<Widget> children;

  PageContent({
    required this.width,
    required this.padding,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        child: Center(
          child: ListView(
            padding: padding,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: children,
          ),
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final List<Widget> children;
  final double width;

  Section({required this.children, required this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: 150),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
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
