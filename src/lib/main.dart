import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: CustomColors.indigo[900],
        textTheme: Theme.of(context).textTheme.copyWith(
              bodyText2: TextStyle(
                color: Colors.white,
              ),
            ),
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.white,
            ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  final PageController pageController = PageController();

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const int NUM_PAGES = 7;

  double currPos = 0.0;
  double prevPos = 0.0;

  @override
  void initState() {
    super.initState();

    widget.pageController.addListener(() {
      setState(() {
        prevPos = currPos;
        currPos = widget.pageController.page! / (NUM_PAGES - 1);
      });
    });
  }

  void _nextPage() {
    widget.pageController.nextPage(
      duration: Duration(seconds: 1),
      curve: Curves.ease,
    );
  }

  void _prevPage() {
    widget.pageController.previousPage(
      duration: Duration(seconds: 1),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewport) {
          return Stack(
            children: <Widget>[
              PageView(
                controller: widget.pageController,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Positioned(
                        bottom: -1,
                        child: Transform.rotate(
                          angle: 0.0 * math.pi,
                          child: ClipPath(
                            clipper: CubicClipper(),
                            child: Container(
                              width: viewport.maxWidth,
                              height: 200,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    CustomColors.violet[500]!,
                                    CustomColors.red[500]!,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("Intro"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: <Widget>[
                      Positioned(
                        top: -1,
                        child: Transform.rotate(
                          angle: math.pi,
                          child: ClipPath(
                            clipper: CubicClipper(),
                            child: Container(
                              height: 300,
                              width: viewport.maxWidth / 3,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    CustomColors.yellow[500]!,
                                    CustomColors.red[500]!,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -1,
                        left: viewport.maxWidth / 3 - 1,
                        child: Transform.rotate(
                          angle: math.pi,
                          child: ClipPath(
                            clipper: CubicClipper(),
                            child: Container(
                              height: 300,
                              width: viewport.maxWidth / 3,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    CustomColors.yellow[500]!,
                                    CustomColors.red[500]!,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -1,
                        left: 2 * viewport.maxWidth / 3 - 2,
                        child: Transform.rotate(
                          angle: math.pi,
                          child: ClipPath(
                            clipper: CubicClipper(),
                            child: Container(
                              height: 300,
                              width: viewport.maxWidth -
                                  2 * viewport.maxWidth / 3 +
                                  3,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    CustomColors.yellow[500]!,
                                    CustomColors.red[500]!,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("About"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Key Competencies"),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Professional Projects"),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Open Source"),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Personal Pursuits"),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Contact"),
                        TextButton(
                          child: const Text("Imprint (DE)"),
                          onPressed: () {
                            launchUrl(Uri.parse("imprint.html"));
                          },
                        ),
                        TextButton(
                          child: const Text("Privacy Policy (DE)"),
                          onPressed: () {
                            launchUrl(Uri.parse("privacy_policy.html"));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                width: viewport.maxWidth,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.expand_less),
                      onPressed: _prevPage,
                    ),
                    Expanded(
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
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.expand_more),
                      onPressed: _nextPage,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class OvalClipper extends CustomClipper<Path> {
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

  @override
  Path getClip(Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );

    final path = Path();

    path.addOval(rect);

    path.close();

    return path;
  }
}

class ConicClipper extends CustomClipper<Path> {
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

  @override
  Path getClip(Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );

    final path = Path();

    path.addOval(rect);

    path.close();

    return path;
  }
}

class CubicClipper extends CustomClipper<Path> {
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, size.height / 2);

    path.cubicTo(
      250,
      250,
      size.width - 250,
      size.height - 250,
      size.width,
      size.height / 2,
    );

    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);

    path.close();

    return path;
  }
}
