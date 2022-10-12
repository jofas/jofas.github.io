import 'dart:math' as math;

import 'package:flutter/material.dart' hide Spacer;
import 'package:flutter/gestures.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'colors.dart';
import 'clipper.dart';
import 'util.dart';
import 'logo.dart';

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
                fontSize: 20,
                height: 1.5,
                letterSpacing: 1,
              ),
              headline2: TextStyle(
                color: Colors.white,
                letterSpacing: 5,
              ),
              headline3: TextStyle(
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
  static const double MAX_CONTENT_WIDTH = 1200;

  double currPos = 0.0;
  double prevPos = 0.0;
  bool hasScrolled = false;

  @override
  void initState() {
    super.initState();

    widget.pageController.addListener(() {
      setState(() {
        prevPos = currPos;
        currPos = widget.pageController.page! / (NUM_PAGES - 1);
        hasScrolled = true;
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

  double _contentWidth(double w) {
    return w > MAX_CONTENT_WIDTH ? MAX_CONTENT_WIDTH : w;
  }

  ButtonStyle _buttonStyle(
    BuildContext context, {
    double? fontSize,
    EdgeInsets? padding,
  }) {
    return ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsets?>(padding),
      overlayColor:
          MaterialStateProperty.all<Color?>(Colors.white.withOpacity(0)),
      foregroundColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) {
          return Colors.white;
        }
        return Colors.grey[400]!;
      }),
      textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
          (Set<MaterialState> states) {
        final base = Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: fontSize,
            );

        if (states.contains(MaterialState.focused)) {
          return base.copyWith(
            decoration: TextDecoration.underline,
          );
        }
        return base;
      }),
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
                      /*
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
                      */
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: _contentWidth(viewport.maxWidth),
                            maxHeight: viewport.maxHeight * 0.9,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Logo(Size(
                              _contentWidth(viewport.maxWidth) - 30,
                              viewport.maxHeight * 0.9,
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: <Widget>[
                      /*
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
                      */
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: _contentWidth(viewport.maxWidth),
                            maxHeight: viewport.maxHeight * 0.9,
                          ),
                          child: Center(
                            child: ListView(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              shrinkWrap: true,
                              children: <Widget>[
                                Text(
                                  "Jonas Fassbender",
                                  style: Theme.of(context).textTheme.headline2,
                                  textAlign: TextAlign.center,
                                ),
                                Spacer.headlineSpace,
                                Text(
                                  "Software engineer and freelancer. In love with the craft.",
                                  textAlign: TextAlign.center,
                                ),
                                Spacer.paragraphSpace,
                                Text(
                                  "In the summer of 2015 I wrote my first program (a Windows Forms app written in VB.NET, believe it or not). Over the course of that fateful summer I quickly became so deeply enamored with programming that I made it my profession.",
                                  textAlign: TextAlign.center,
                                ),
                                Spacer.paragraphSpace,
                                Text(
                                  "Since then I've successfully attained two higher education degrees in computing, lived in two countries, became a freelancer and open source contributor, created and maintained a microservice application with over seventy thousand lines of code all by myself, programmed supercomputers including a neuromorphic one with over one million cores (SpiNNaker), tried to teach machines how to see and how to conservatively predict whether a loan request is likely to default, learned a lot, failed many times and had the time of my life doing it all.",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: _contentWidth(viewport.maxWidth),
                        maxHeight: viewport.maxHeight * 0.9,
                      ),
                      child: Center(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          shrinkWrap: true,
                          children: <Widget>[
                            Text(
                              "Key Competencies",
                              style: Theme.of(context).textTheme.headline2,
                              textAlign: TextAlign.center,
                            ),
                            Spacer.headlineSpace,
                            Text(
                              "What I can do to help you successfully realize your idea and mold it into software:",
                              textAlign: TextAlign.center,
                            ),
                            Spacer.paragraphSpace,
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.architecture,
                                  size: 80,
                                ),
                                Spacer.tileSpace,
                                Expanded(
                                  child: Text(
                                    "Software Architecture. Microservices or a monolith? On-premises, cloud, hybrid or multi-cloud? Which 3rd-party vendors or open source technologies fit best? Together we will figure that out. We will deconstruct your problem using Domain Driven Design and create a scalable and maintainable application for you.",
                                  ),
                                ),
                              ],
                            ),
                            Spacer.paragraphSpace,
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.code,
                                  size: 80,
                                ),
                                Spacer.tileSpace,
                                Expanded(
                                  child: Text(
                                    "Clean Code. A maintainable software project that will run for a long time may start with a good, domain-driven architecture. But in the end, it's about the implementation. Let's make the internet a tiny bit better by writing well-tested and easy-to-read software to prevent the next big data leak.",
                                  ),
                                ),
                              ],
                            ),
                            Spacer.paragraphSpace,
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.lan,
                                  size: 80,
                                ),
                                Spacer.tileSpace,
                                Expanded(
                                  child: Text(
                                    "Distributed Systems. High performance and high availability computing is fun. Unfortunately, distributed systems are still very complex. It's hard to figure out communication, synchronization and fault tolerance. Together we will scale up your system while keeping track of all the moving parts.",
                                  ),
                                ),
                              ],
                            ),
                            Spacer.paragraphSpace,
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.smart_toy,
                                  size: 80,
                                ),
                                Spacer.tileSpace,
                                Expanded(
                                  child: Text(
                                    "Machine Learning. The idea of teaching computers how to solve complex tasks from data is very alluring and shows promising results. Having experience with supervised machine learning and conformal prediction on real-world data sets, I'd love to teach computers to make descisions based on your data.",
                                  ),
                                ),
                              ],
                            ),
                            Spacer.paragraphSpace,
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.devices,
                                  size: 80,
                                ),
                                Spacer.tileSpace,
                                Expanded(
                                  child: Text(
                                    "Cross Platform. In the end, software is all about people. And most people interact with computers through a graphical user interface. Having experience with Flutter and Material Design in production, I can help you get your Flutter app off the ground and reach your clients on every device.",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: _contentWidth(viewport.maxWidth),
                        maxHeight: viewport.maxHeight * 0.9,
                      ),
                      child: Center(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          shrinkWrap: true,
                          children: <Widget>[
                            Text(
                              "Professional Projects",
                              style: Theme.of(context).textTheme.headline2,
                              textAlign: TextAlign.center,
                            ),
                            Spacer.headlineSpace,
                            Text(
                              "The main projects I am working on or have worked on as a freelancing software engineer:",
                              textAlign: TextAlign.center,
                            ),
                            Spacer.paragraphSpace,
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.directions_car,
                                  size: 80,
                                ),
                                Spacer.tileSpace,
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Container(
                                            height: 28,
                                            child: TextButton(
                                              style: _buttonStyle(
                                                context,
                                                padding: EdgeInsets.all(0),
                                              ),
                                              child: Text("Carpolice.de."),
                                              onPressed: () {
                                                launchUrl(Uri.parse(
                                                  "https://carpolice.de",
                                                ));
                                              },
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              " The carpolice.de InsurTech platform serves car dealers who want to provide their customers with an all-inclusive offer including car insurance. Carpolice.de provides car dealers with an easy-to-use system with products specially designed for car dealerships.",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer.paragraphSpace,
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.school,
                                  size: 80,
                                ),
                                Spacer.tileSpace,
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Container(
                                            height: 28,
                                            child: TextButton(
                                              style: _buttonStyle(
                                                context,
                                                padding: EdgeInsets.all(0),
                                              ),
                                              child: Text(
                                                "German Sport University Cologne.",
                                              ),
                                              onPressed: () {
                                                launchUrl(Uri.parse(
                                                  "https://www.dshs-koeln.de",
                                                ));
                                              },
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              " Written the technical domain specification for an application enabling teachers to generate rich semester plans applying inquiry-based learning. The tool should guide teachers through the generation steps with the help of a recommendation system. Currently in the stage of raising funds for the development.",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer.paragraphSpace,
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.account_balance,
                                  size: 80,
                                ),
                                Spacer.tileSpace,
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Container(
                                            height: 28,
                                            child: TextButton(
                                              style: _buttonStyle(
                                                context,
                                                padding: EdgeInsets.all(0),
                                              ),
                                              child: Text(
                                                  "Undisclosed German bank."),
                                              onPressed: () {
                                                launchUrl(Uri.parse(
                                                  "cp_for_loan_approval_prediction.pdf",
                                                ));
                                              },
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: " ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: _contentWidth(viewport.maxWidth),
                        maxHeight: viewport.maxHeight * 0.9,
                      ),
                      child: Center(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          shrinkWrap: true,
                          children: <Widget>[
                            Text(
                              "Open Source",
                              style: Theme.of(context).textTheme.headline2,
                              textAlign: TextAlign.center,
                            ),
                            Spacer.headlineSpace,
                            Text(
                              "Open source projects I am currently working on:",
                              textAlign: TextAlign.center,
                            ),
                            Spacer.paragraphSpace,
                            Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.rust,
                                  size: 80,
                                ),
                                Spacer.tileSpace,
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Container(
                                            height: 28,
                                            child: TextButton(
                                              style: _buttonStyle(
                                                context,
                                                padding: EdgeInsets.all(0),
                                              ),
                                              child: Text("My Rust crates."),
                                              onPressed: () {
                                                launchUrl(Uri.parse(
                                                  "https://crates.io/users/jofas",
                                                ));
                                              },
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              " Mainly declarative and procedural macros, serde and actix-web related utility crates.  Browse through them and hopefully you'll find something that can help you with your Rust project.",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer.paragraphSpace,
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.brush,
                                  size: 80,
                                ),
                                Spacer.tileSpace,
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Container(
                                            height: 28,
                                            child: TextButton(
                                              style: _buttonStyle(
                                                context,
                                                padding: EdgeInsets.all(0),
                                              ),
                                              child: Text("Mgart."),
                                              onPressed: () {
                                                launchUrl(Uri.parse(
                                                  "https://github.com/jofas/mgart",
                                                ));
                                              },
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              " Pronounced \"em-gart.\" I find the beauty of mathematical structures and algorithms very enticing. So I build a program that lets you generate your own algorithmic art with a simple-to-use declarative API.",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer.paragraphSpace,
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.receipt_long,
                                  size: 80,
                                ),
                                Spacer.tileSpace,
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Container(
                                            height: 28,
                                            child: TextButton(
                                              style: _buttonStyle(
                                                context,
                                                padding: EdgeInsets.all(0),
                                              ),
                                              child: Text("BAREKEEPER."),
                                              onPressed: () {
                                                launchUrl(Uri.parse(
                                                  "https://github.com/jofas/BAREKEEPER",
                                                ));
                                              },
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              " As a freelancer, you have several options when it comes to making your taxes and other business needs, like invoicing or hour tracking. None fit my needs, so I created a free bare-metal tool where you have full control over your data. Best part? You don't even have to leave your terminal.",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: _contentWidth(viewport.maxWidth),
                        maxHeight: viewport.maxHeight * 0.9,
                      ),
                      child: Center(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          shrinkWrap: true,
                          children: <Widget>[
                            Text(
                              "Personal Pursuits",
                              style: Theme.of(context).textTheme.headline2,
                              textAlign: TextAlign.center,
                            ),
                            Spacer.headlineSpace,
                            Text(
                              "Besides honing my skills as a software engineer and professional I particularly enjoy the following activities:",
                              textAlign: TextAlign.center,
                            ),
                            Spacer.paragraphSpace,
                            // TODO: abstract
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.self_improvement,
                                  size: 80,
                                ),
                                Spacer.tileSpace,
                                Expanded(
                                  child: Text(
                                    "Meditation. I meditate to find truth and experience freedom, calmness and peace of mind.",
                                  ),
                                ),
                              ],
                            ),
                            Spacer.paragraphSpace,
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.science,
                                  size: 80,
                                ),
                                Spacer.tileSpace,
                                Expanded(
                                  child: Text(
                                    "Fermentation. Kimchi, sauerkraut, hot sauce or veggies. There is no greater joy than eating a slice of freshly made sourdough bread.",
                                  ),
                                ),
                              ],
                            ),
                            Spacer.paragraphSpace,
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.hiking,
                                  size: 80,
                                ),
                                Spacer.tileSpace,
                                Expanded(
                                  child: Text(
                                    "Long distance hiking. My goal is to one day walk a 2000 mile trail.",
                                  ),
                                ),
                              ],
                            ),
                            Spacer.paragraphSpace,
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.fitness_center,
                                  size: 80,
                                ),
                                Spacer.tileSpace,
                                Expanded(
                                  child: Text(
                                    "Olympic weightlifting. Few sports combine strength, speed and overall athleticism in such an aesthetic and rewarding way.",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: _contentWidth(viewport.maxWidth),
                        maxHeight: viewport.maxHeight * 0.9,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    Text(
                                      "Contact",
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                      textAlign: TextAlign.center,
                                    ),
                                    Spacer.headlineSpace,
                                    Text(
                                      "If you are interested in collaborating on a project, be that professional work or open source, feel free to write me an email.",
                                      textAlign: TextAlign.center,
                                    ),
                                    Spacer.paragraphSpace,
                                    Text(
                                      "If you got something funny or wholesome and wish to share it with me, do so as well.",
                                      textAlign: TextAlign.center,
                                    ),
                                    Spacer.paragraphSpace,
                                    TextButton(
                                      style: _buttonStyle(context),
                                      child: const Text(
                                        "jonas@fassbender.dev",
                                        textAlign: TextAlign.center,
                                      ),
                                      onPressed: () {
                                        launchUrl(Uri.parse(
                                          "mailto://jonas@fassbender.dev?subject=Hi%20There!",
                                        ));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  style: _buttonStyle(
                                    context,
                                    fontSize: 10,
                                  ),
                                  child: const Text("Imprint (DE)"),
                                  onPressed: () {
                                    launchUrl(Uri.parse("imprint.html"));
                                  },
                                ),
                                TextButton(
                                  style: _buttonStyle(
                                    context,
                                    fontSize: 10,
                                  ),
                                  child: const Text("Privacy Policy (DE)"),
                                  onPressed: () {
                                    launchUrl(Uri.parse("privacy_policy.html"));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 5,
                bottom: 0.065 * viewport.maxHeight,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        style: _buttonStyle(
                          context,
                          fontSize: 12,
                        ),
                        child: const Text("GITHUB"),
                        onPressed: () {
                          launchUrl(Uri.parse("https://github.com/jofas"));
                        },
                      ),
                      TextButton(
                        style: _buttonStyle(
                          context,
                          fontSize: 12,
                        ),
                        child: const Text("GITLAB"),
                        onPressed: () {
                          launchUrl(Uri.parse("https://gitlab.com/jofas"));
                        },
                      ),
                      TextButton(
                        style: _buttonStyle(
                          context,
                          fontSize: 12,
                        ),
                        child: const Text("RESUME"),
                        onPressed: () {
                          launchUrl(Uri.parse("resume.pdf"));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0.025 * viewport.maxHeight,
                left: viewport.maxWidth / 2 -
                    _contentWidth(viewport.maxWidth) / 2,
                width: _contentWidth(viewport.maxWidth),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
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
                                backgroundColor: Colors.white,
                                color: CustomColors.red[300],
                                minHeight: 10,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 25),
                      Text(
                        "${(currPos * (NUM_PAGES - 1)).round() + 1}  /  $NUM_PAGES",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 12,
                            ),
                      ),
                      SizedBox(width: 10),
                      _prevPageButton,
                      _nextPageButton,
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget get _prevPageButton {
    return IconButton(
      icon: const Icon(Icons.expand_less),
      tooltip: "Page Up",
      splashRadius: 1,
      onPressed: _prevPage,
    );
  }

  Widget get _nextPageButton {
    final button = IconButton(
      icon: const Icon(Icons.expand_more),
      tooltip: "Page Down",
      splashRadius: 1,
      onPressed: _nextPage,
    );

    if (hasScrolled) {
      return button;
    } else {
      return JumpAnimation(
        child: button,
      );
    }
  }
}
