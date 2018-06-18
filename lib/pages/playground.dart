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
    controller = new AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    final CurvedAnimation curve = new CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    animation = new Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });

    reverseAnimation = new Tween(begin: 1.0, end: 0.0).animate(curve);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new Transform(
        transform: new Matrix4.translationValues(0.0, 18.0 * animation.value, 0.0),
        child: ScaleTransition(
          scale: reverseAnimation,
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            child: Icon(Icons.search),
            elevation: reverseAnimation.value * 6.0,
            onPressed: () => controller.forward(),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey,
            ),
          ),
          new Material(
            elevation: 8.0,
            child: Container(
              height: animation.value * 56.0,
              color: Colors.blue,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => controller.reverse(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
