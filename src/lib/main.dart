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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final PageController pageController = PageController();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewport) {
        final screenSize = screenSizeFromViewport(viewport);

        late final fontSizeBody;
        late final fontSizeHeadline;
        late final iconSize;
        late final textButtonSize;
        late final linkHeight;
        late final scrollProgressBarHeight;
        late final scrollProgressBarIconSize;
        late final navbarButtonSize;

        if (screenSize == ScreenSize.sm) {
          fontSizeBody = 12;
          fontSizeHeadline = 24;
          iconSize = 30;
          textButtonSize = 8;
          linkHeight = 17.25;
          scrollProgressBarHeight = 5;
          scrollProgressBarIconSize = 14;
          navbarButtonSize = 20;
        } else if (screenSize == ScreenSize.md) {
          fontSizeBody = 16;
          fontSizeHeadline = 40;
          iconSize = 50;
          textButtonSize = 10;
          linkHeight = 22.75;
          scrollProgressBarHeight = 8;
          scrollProgressBarIconSize = 16;
          navbarButtonSize = 25;
        } else {
          fontSizeBody = 20;
          fontSizeHeadline = 60;
          iconSize = 70;
          textButtonSize = 12;
          linkHeight = 28.5;
          scrollProgressBarHeight = 10;
          scrollProgressBarIconSize = 20;
          navbarButtonSize = 30;
        }

        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            scaffoldBackgroundColor: CustomColors.indigo[900],
            textTheme: TextTheme(
              bodyText2: TextStyle(
                color: Colors.white,
                fontSize: fontSizeBody,
                height: 1.5,
                letterSpacing: 1,
              ),
              headline2: TextStyle(
                color: Colors.white,
                fontSize: fontSizeHeadline,
                letterSpacing: 5,
              ),
              labelMedium: TextStyle(
                color: Colors.white,
                fontSize: textButtonSize,
                letterSpacing: 1,
              ),
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
              size: iconSize,
            ),
            dividerTheme: DividerThemeData(
              color: Colors.white,
              thickness: 2,
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets?>(
                  EdgeInsets.symmetric(horizontal: 10),
                ),
                minimumSize: MaterialStateProperty.all<Size?>(Size(0, 0)),
                overlayColor: MaterialStateProperty.all<Color?>(
                  Colors.white.withOpacity(0),
                ),
                foregroundColor: MaterialStateProperty.resolveWith<Color>((
                  Set<MaterialState> states,
                ) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.white;
                  }
                  return Colors.grey[400]!;
                }),
                textStyle: MaterialStateProperty.resolveWith<TextStyle?>((
                  Set<MaterialState> states,
                ) {
                  final base = Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontSize: textButtonSize,
                      );

                  if (states.contains(MaterialState.focused)) {
                    return base.copyWith(
                      decoration: TextDecoration.underline,
                    );
                  }
                  return base;
                }),
              ),
            ),
          ),
          home: MyHomePage(
            width: viewport.maxWidth,
            height: viewport.maxHeight,
            pageController: pageController,
            linkHeight: linkHeight,
            scrollProgressBarHeight: scrollProgressBarHeight,
            scrollProgressBarIconSize: scrollProgressBarIconSize,
            navbarButtonSize: navbarButtonSize,
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  static const int NUM_PAGES = 7;
  static const double MAX_CONTENT_WIDTH = 1200;

  final PageController pageController;
  final double width, height;

  final double linkHeight;
  final double scrollProgressBarHeight;
  final double scrollProgressBarIconSize;
  final double navbarButtonSize;

  MyHomePage({
    required this.width,
    required this.height,
    required this.pageController,
    required this.linkHeight,
    required this.scrollProgressBarHeight,
    required this.scrollProgressBarIconSize,
    required this.navbarButtonSize,
  });

  double get _contentWidth {
    return width > MAX_CONTENT_WIDTH ? MAX_CONTENT_WIDTH : width;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: CustomColors.indigo[900],
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              width: 100,
              height: 100,
              child: Logo(),
            ),
            Divider(),
            NavButton(
              text: "START",
              page: 0,
              controller: pageController,
            ),
            NavButton(
              text: "ABOUT",
              page: 1,
              controller: pageController,
            ),
            NavButton(
              text: "KEY COMPETENCIES",
              page: 2,
              controller: pageController,
            ),
            NavButton(
              text: "PROFESSIONAL PROJECTS",
              page: 3,
              controller: pageController,
            ),
            NavButton(
              text: "OPEN SOURCE",
              page: 4,
              controller: pageController,
            ),
            NavButton(
              text: "PERSONAL PURSUITS",
              page: 5,
              controller: pageController,
            ),
            NavButton(
              text: "CONTACT",
              page: 6,
              controller: pageController,
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          PageView(
            controller: pageController,
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
                        maxWidth: _contentWidth,
                        maxHeight: height - 30,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: AnimatedLogo(),
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
                              width: height
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
                        maxWidth: _contentWidth,
                        maxHeight: height - 30,
                      ),
                      child: Center(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 50),
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
                    maxWidth: _contentWidth,
                    maxHeight: height - 30,
                  ),
                  child: Center(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 50),
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
                            Icon(Icons.architecture),
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
                            Icon(Icons.code),
                            Spacer.tileSpace,
                            Expanded(
                              child: Text(
                                "Clean Code. A maintainable software project that will run for a long time may start with a good, domain-driven architecture. But in the end, it's about the implementation. Let's make the internet a tiny bit better by writing well-tested and easy-to-read code to prevent the next big data leak.",
                              ),
                            ),
                          ],
                        ),
                        Spacer.paragraphSpace,
                        Row(
                          children: <Widget>[
                            Icon(Icons.lan),
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
                            Icon(Icons.smart_toy),
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
                            Icon(Icons.devices),
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
                    maxWidth: _contentWidth,
                    maxHeight: height - 30,
                  ),
                  child: Center(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 50),
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
                            Icon(Icons.directions_car),
                            Spacer.tileSpace,
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    InlineLink(
                                      text: "Carpolice.de.",
                                      url: "https://carpolice.de",
                                      height: linkHeight,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText2!,
                                    ),
                                    TextSpan(
                                      text:
                                          " The carpolice.de InsurTech platform serves car dealers who want to provide their customers with an all-inclusive offer including car insurance. Carpolice.de provides car dealers with an easy-to-use system for selling insurance products specially designed for car dealerships.",
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
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
                            Icon(Icons.school),
                            Spacer.tileSpace,
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    InlineLink(
                                      text: "German Sport Univerity Cologne.",
                                      url: "https://www.dshs-koeln.de",
                                      height: linkHeight,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText2!,
                                    ),
                                    TextSpan(
                                      text:
                                          " Written the technical domain specification for an application enabling teachers to generate rich semester plans applying inquiry-based learning. The tool should guide teachers through the generation steps with the help of a recommendation system. Currently in the stage of raising funds for the development.",
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
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
                            Icon(Icons.account_balance),
                            Spacer.tileSpace,
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    InlineLink(
                                      text: "Undisclosed German bank.",
                                      url:
                                          "cp_for_loan_approval_prediction.pdf",
                                      height: linkHeight,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText2!,
                                    ),
                                    TextSpan(
                                      text:
                                          " Applied an adaptation of the conformal prediction method to the consumer loan data of a German bank. The goal was to save the bank money by rejecting loan requests likely to default as early in the approval process as possible. 17% of all declined requests were filtered out by the algorithm while retaining an accuracy of 98%.",
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
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
                    maxWidth: _contentWidth,
                    maxHeight: height - 30,
                  ),
                  child: Center(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 50),
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
                            Icon(FontAwesomeIcons.rust),
                            Spacer.tileSpace,
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    InlineLink(
                                      text: "My Rust crates.",
                                      url: "https://crates.io/users/jofas",
                                      height: linkHeight,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText2!,
                                    ),
                                    TextSpan(
                                      text:
                                          " Mainly declarative and procedural macros, serde and actix-web related utility crates.  Browse through them and hopefully you'll find something that can help you with your Rust project.",
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
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
                            Icon(Icons.brush),
                            Spacer.tileSpace,
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    InlineLink(
                                      text: "Mgart.",
                                      url: "https://github.com/jofas/mgart",
                                      height: linkHeight,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText2!,
                                    ),
                                    TextSpan(
                                      text:
                                          " Pronounced \"em-gart.\" I find the beauty of mathematical structures and algorithms very enticing. So I build a program that lets you generate your own algorithmic art with a simple-to-use declarative API.",
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
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
                            Icon(Icons.receipt_long),
                            Spacer.tileSpace,
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    InlineLink(
                                      text: "BAREKEEPER.",
                                      url:
                                          "https://github.com/jofas/BAREKEEPER",
                                      height: linkHeight,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText2!,
                                    ),
                                    TextSpan(
                                      text:
                                          " As a freelancer, you have several options when it comes to making your taxes and other business needs, like invoicing or hour tracking. None fit my needs, so I created a free bare-metal tool where you have full control over your data. Best part? You don't even have to leave your terminal.",
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
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
                    maxWidth: _contentWidth,
                    maxHeight: height - 30,
                  ),
                  child: Center(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 50),
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
                        Row(
                          children: <Widget>[
                            Icon(Icons.self_improvement),
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
                            Icon(Icons.science),
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
                            Icon(Icons.hiking),
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
                            Icon(Icons.fitness_center),
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
                    maxWidth: _contentWidth,
                    maxHeight: height - 30,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                Text(
                                  "Contact",
                                  style: Theme.of(context).textTheme.headline2,
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
                                Link(
                                  text: "jonas@fassbender.dev",
                                  url:
                                      "mailto://jonas@fassbender.dev?subject=Hi%20There!",
                                  height: linkHeight,
                                  textStyle:
                                      Theme.of(context).textTheme.bodyText2!,
                                  textAlign: TextAlign.center,
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 5,
            top: 10,
            child: NavbarButton(
              size: navbarButtonSize,
            ),
          ),
          Positioned(
            right: 5,
            bottom: 0,
            child: RotatedBox(
              quarterTurns: 3,
              child: Row(
                children: <Widget>[
                  TextButton(
                    child: const Text("GITHUB"),
                    onPressed: () {
                      launchUrl(Uri.parse("https://github.com/jofas"));
                    },
                  ),
                  TextButton(
                    child: const Text("GITLAB"),
                    onPressed: () {
                      launchUrl(Uri.parse("https://gitlab.com/jofas"));
                    },
                  ),
                  TextButton(
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
            bottom: 5,
            left: width / 2 - _contentWidth / 2,
            width: _contentWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: ScrollProgressBar(
                controller: pageController,
                pages: NUM_PAGES,
                height: scrollProgressBarHeight,
                iconSize: scrollProgressBarIconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
