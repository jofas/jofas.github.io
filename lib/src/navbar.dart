import 'package:flutter/material.dart';

import 'logo.dart' show Logo;

class OpenNavbarButton extends StatelessWidget {
  final double size;

  OpenNavbarButton({required this.size});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Icon(Icons.menu, size: size),
      onPressed: () => Scaffold.of(context).openDrawer(),
    );
  }
}

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
  late final page;

  @override
  void initState() {
    super.initState();
    page = widget.controller.page!.round();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
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
                color: Colors.black,
              ),
            ),
          ),
          Divider(),
          NavButton(
            text: "ABOUT",
            page: 0,
            controller: widget.controller,
          ),
          NavButton(
            text: "KEY COMPETENCIES",
            page: 1,
            controller: widget.controller,
          ),
          NavButton(
            text: "CORE VALUES",
            page: 2,
            controller: widget.controller,
          ),
          NavButton(
            text: "PROFESSIONAL PROJECTS",
            page: 3,
            controller: widget.controller,
          ),
          NavButton(
            text: "OPEN SOURCE",
            page: 4,
            controller: widget.controller,
          ),
          NavButton(
            text: "PERSONAL PURSUITS",
            page: 5,
            controller: widget.controller,
          ),
          NavButton(
            text: "CONTACT",
            page: 6,
            controller: widget.controller,
          ),
        ],
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  final String text;
  final int page;
  final PageController controller;

  late final bool _isActive;

  NavButton({
    required this.text,
    required this.page,
    required this.controller,
  }) {
    _isActive = controller.page!.round() == page;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets?>(
          EdgeInsets.symmetric(vertical: 2.5),
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle?>((
          Set<MaterialState> states,
        ) {
          final style = Theme.of(context).textTheme.bodyText2!.copyWith(
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
