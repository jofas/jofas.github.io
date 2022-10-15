import 'package:flutter/material.dart';

import 'logo.dart' show Logo;

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
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
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
              child: Logo(),
            ),
          ),
          Divider(),
          NavButton(
            text: "START",
            page: 0,
            controller: widget.controller,
          ),
          NavButton(
            text: "ABOUT",
            page: 1,
            controller: widget.controller,
          ),
          NavButton(
            text: "KEY COMPETENCIES",
            page: 2,
            controller: widget.controller,
          ),
          NavButton(
            text: "CORE VALUES",
            page: 3,
            controller: widget.controller,
          ),
          NavButton(
            text: "PROFESSIONAL PROJECTS",
            page: 4,
            controller: widget.controller,
          ),
          NavButton(
            text: "OPEN SOURCE",
            page: 5,
            controller: widget.controller,
          ),
          NavButton(
            text: "PERSONAL PURSUITS",
            page: 6,
            controller: widget.controller,
          ),
          NavButton(
            text: "CONTACT",
            page: 7,
            controller: widget.controller,
          ),
        ],
      ),
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
