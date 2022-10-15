import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'util.dart' show InverseButtonStyle;

class Linkbar extends StatefulWidget {
  final PageController controller;

  Linkbar({required this.controller});

  @override
  State<Linkbar> createState() => _LinkbarState();
}

class _LinkbarState extends State<Linkbar> {
  late final void Function() _listener;

  int page = 0;

  @override
  void initState() {
    super.initState();

    _listener = () {
      final newPage = widget.controller.page!.round();

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
    final inverted = page % 2 == 1;

    return RotatedBox(
      quarterTurns: 3,
      child: Row(
        children: <Widget>[
          TextButton(
            style: inverted
                ? Theme.of(context).textButtonTheme!.style!.inverse()
                : Theme.of(context).textButtonTheme!.style!,
            child: const Text("GITHUB"),
            onPressed: () {
              launchUrl(Uri.parse("https://github.com/jofas"));
            },
          ),
          TextButton(
            style: inverted
                ? Theme.of(context).textButtonTheme!.style!.inverse()
                : Theme.of(context).textButtonTheme!.style!,
            child: const Text("GITLAB"),
            onPressed: () {
              launchUrl(Uri.parse("https://gitlab.com/jofas"));
            },
          ),
          TextButton(
            style: inverted
                ? Theme.of(context).textButtonTheme!.style!.inverse()
                : Theme.of(context).textButtonTheme!.style!,
            child: const Text("RESUME"),
            onPressed: () {
              launchUrl(Uri.parse("resume.pdf"));
            },
          ),
        ],
      ),
    );
  }
}
