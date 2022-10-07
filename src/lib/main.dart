import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import 'colors.dart';
import 'clipper.dart';

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
                            clipper: SmoothCurveClipper(
                              points: <Vector2>[
                                Vector2(0, 0.5),
                                Vector2(0.25, 0.25),
                                Vector2(0.5, 0.5),
                                Vector2(0.75, 0.25),
                                Vector2(1, 0.5),
                              ],
                              smoothness: 0.3,
                            ),
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
                      Positioned(
                        bottom: 100,
                        left: 100,
                        child: Transform.rotate(
                          angle: 0.0 * math.pi,
                          child: ClipPath(
                            clipper: SmoothShapeClipper(
                              points: <Vector2>[
                                Vector2(0.1, 0.5),
                                Vector2(0.5, 0.6),
                                Vector2(0.2, 0.3),
                                Vector2(0.5, 0.1),
                                Vector2(0.6, 0.5),
                                Vector2(0.8, 0.8),
                                Vector2(0.5, 0.9),
                              ],
                              smoothness: 0.66,
                            ),
                            child: Container(
                              width: 600,
                              height: 600,
                              color: CustomColors.red[500],
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
                            clipper: SmoothCurveClipper(
                              points: <Vector2>[
                                Vector2(0, 0.5),
                                Vector2(0.2, 0.4),
                                Vector2(0.1, 0.2),
                                Vector2(0.7, 0.6),
                                Vector2(0.85, 0.4),
                                Vector2(1, 0.7),
                              ],
                              smoothness: 0.6,
                            ),
                            child: Container(
                              width: viewport.maxWidth,
                              height: 300,
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
