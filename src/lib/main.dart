import 'package:flutter/material.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final PageController _pageController = PageController();

  void _nextPage() {
    _pageController.nextPage(
      duration: Duration(seconds: 1),
      curve: Curves.ease,
    );
  }

  void _prevPage() {
    _pageController.previousPage(
      duration: Duration(seconds: 1),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("1"),
                IconButton(
                  icon: const Icon(Icons.expand_more),
                  onPressed: _nextPage,
                ),
              ]
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("2"),
                IconButton(
                  icon: const Icon(Icons.expand_less),
                  onPressed: _prevPage,
                ),
                IconButton(
                  icon: const Icon(Icons.expand_more),
                  onPressed: _nextPage,
                ),
              ]
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("3"),
                IconButton(
                  icon: const Icon(Icons.expand_less),
                  onPressed: _prevPage,
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}
