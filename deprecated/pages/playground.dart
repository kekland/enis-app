import 'package:flutter/material.dart';

class PlaygroundPage extends StatefulWidget {
  @override
  _PlaygroundPageState createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  Animation<double> reverseAnimation;
  AnimationController controller;

  initState() {
    super.initState();
    controller = new AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    final CurvedAnimation curve = new CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    animation = new Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });

    reverseAnimation = new Tween(begin: 1.0, end: 0.0).animate(curve);
  }

  bool isSearchOpen = false;
  switchSearch() {
    isSearchOpen = !isSearchOpen;

    if (isSearchOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
