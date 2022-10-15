import 'package:flutter/material.dart';

import 'logo.dart' show Logo;
import 'util.dart' show InverseTextStyle;

class Navbar extends StatefulWidget {
  final PageController controller;

  final double logoSize;
  final double logoPadding;

  Navbar({
    required this.controller,
    required this.logoSize,
    required this.logoPadding,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int page = 0;

  @override
  void initState() {
    super.initState();
    page = widget.controller.page!.round();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2!;

    final inverted = page % 2 == 0;

    return Drawer(
      backgroundColor: inverted ? Colors.white : Colors.black,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: widget.logoPadding,
            ),
            child: SizedBox(
              width: widget.logoSize,
              height: widget.logoSize,
              child: Logo(
                color: inverted ? Colors.black : Colors.white,
              ),
            ),
          ),
          Divider(
            color: inverted ? Colors.black : Colors.white,
          ),
          NavButton(
            text: "START",
            page: 0,
            controller: widget.controller,
            textStyle: inverted ? textStyle.inverse() : textStyle,
          ),
          NavButton(
            text: "ABOUT",
            page: 1,
            controller: widget.controller,
            textStyle: inverted ? textStyle.inverse() : textStyle,
          ),
          NavButton(
            text: "KEY COMPETENCIES",
            page: 2,
            controller: widget.controller,
            textStyle: inverted ? textStyle.inverse() : textStyle,
          ),
          NavButton(
            text: "CORE VALUES",
            page: 3,
            controller: widget.controller,
            textStyle: inverted ? textStyle.inverse() : textStyle,
          ),
          NavButton(
            text: "PROFESSIONAL PROJECTS",
            page: 4,
            controller: widget.controller,
            textStyle: inverted ? textStyle.inverse() : textStyle,
          ),
          NavButton(
            text: "OPEN SOURCE",
            page: 5,
            controller: widget.controller,
            textStyle: inverted ? textStyle.inverse() : textStyle,
          ),
          NavButton(
            text: "PERSONAL PURSUITS",
            page: 6,
            controller: widget.controller,
            textStyle: inverted ? textStyle.inverse() : textStyle,
          ),
          NavButton(
            text: "CONTACT",
            page: 7,
            controller: widget.controller,
            textStyle: inverted ? textStyle.inverse() : textStyle,
          ),
        ],
      ),
    );
  }
}

class OpenNavbarButton extends StatefulWidget {
  final PageController controller;

  final double size;

  OpenNavbarButton({required this.controller, required this.size});

  @override
  State<OpenNavbarButton> createState() => _OpenNavbarButtonState();
}

class _OpenNavbarButtonState extends State<OpenNavbarButton> {
  late final void Function() _listener;

  int page = 0;

  @override
  void initState() {
    super.initState();

    _listener = () {
      final newPage = ((widget.controller.page ?? 0) + 0.02).floor();

      print("newPage: $newPage");

      if (newPage != page) {
        setState(() {
          page = newPage;
        });
      }
    };

    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Icon(
        Icons.menu,
        color: page % 2 == 0 ? Colors.white : Colors.black,
        size: widget.size,
      ),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}

class NavButton extends StatelessWidget {
  final String text;
  final int page;
  final PageController controller;
  final TextStyle textStyle;

  late final bool _isActive;

  NavButton({
    required this.text,
    required this.page,
    required this.controller,
    required this.textStyle,
  }) {
    _isActive = controller.page!.round() == page;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets?>(
          EdgeInsets.only(top: 20),
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color?>((
          Set<MaterialState> states,
        ) {
          if (_isActive || states.contains(MaterialState.hovered)) {
            return textStyle.color;
          }
        }),
        textStyle: MaterialStateProperty.resolveWith<TextStyle?>((
          Set<MaterialState> states,
        ) {
          final style = textStyle.copyWith(
            fontWeight: _isActive ? FontWeight.bold : null,
          );

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
        if (!_isActive) {
          Scaffold.of(context).closeDrawer();
          controller.animateToPage(
            page,
            duration: Duration(seconds: 1),
            curve: Curves.ease,
          );
        }
      },
    );
  }
}
