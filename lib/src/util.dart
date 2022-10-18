import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'colors.dart';

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
  final Widget? footer;

  PageContent({
    required this.width,
    double? height,
    required this.padding,
    required this.children,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
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
  final TextStyle? style;

  Tile({
    required this.icon,
    required this.title,
    required this.content,
    this.linkHeight,
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
        height: linkHeight!,
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
                foregroundColor: MaterialStateProperty.resolveWith<Color?>((
                  Set<MaterialState> states,
                ) {
                  if (states.contains(MaterialState.hovered)) {
                    return style.color;
                  }
                }),
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
