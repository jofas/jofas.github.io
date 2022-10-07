import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

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

/// http://scaledinnovation.com/analytics/splines/aboutSplines.html
///
class SmoothShapeClipper extends CustomClipper<Path> {
  final List<Vector2> points;
  final double smoothness;

  SmoothShapeClipper({
    required this.points,
    this.smoothness: 0.5,
  }) : super();

  void _computeControlPoints(int i, List<ControlPoints> cps) {}

  @override
  Path getClip(Size size) {
    final scale = Vector2(size.width, size.height);

    final sp = points.map((x) => x.clone()..multiply(scale)).toList();

    final cps = List<ControlPoints>.generate(
      points.length,
      (_) => ControlPoints(),
    );

    for (int i = 0; i < sp.length; i++) {
      final p0 = sp[i % sp.length];
      final p1 = sp[(i + 1) % sp.length];
      final p2 = sp[(i + 2) % sp.length];

      final d01 =
          math.sqrt(math.pow(p1.x - p0.x, 2) + math.pow(p1.y - p0.y, 2));
      final d12 =
          math.sqrt(math.pow(p2.x - p1.x, 2) + math.pow(p2.y - p1.y, 2));

      final fa = smoothness * d01 / (d01 + d12);
      final fb = smoothness * d12 / (d01 + d12);

      cps[i % cps.length].b = p1 - (p2 - p0) * fa;
      cps[(i + 1) % cps.length].a = p1 + (p2 - p0) * fb;
    }

    final path = Path();

    path.moveTo(sp[0].x, sp[0].y);

    for (int i = 0; i < sp.length; i++) {
      path.cubicTo(
        cps[i].a!.x,
        cps[i].a!.y,
        cps[i].b!.x,
        cps[i].b!.y,
        sp[(i + 1) % sp.length].x,
        sp[(i + 1) % sp.length].y,
      );
    }

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ControlPoints {
  Vector2? a;
  Vector2? b;

  @override
  String toString() {
    return "(a: $a b: $b)";
  }
}
