import 'package:flutter/material.dart';

import '../global.dart';

class AnimatedCircularProgressWidget extends StatefulWidget {
  final double value;
  final Color color;

  AnimatedCircularProgressWidget({this.value, this.color});
  @override
  _AnimatedCircularProgressWidgetState createState() => new _AnimatedCircularProgressWidgetState();
}

class _AnimatedCircularProgressWidgetState extends State<AnimatedCircularProgressWidget> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();
    if (Global.animate) {
      controller = new AnimationController(duration: Duration(milliseconds: 750), vsync: this);
      final CurvedAnimation curve = new CurvedAnimation(parent: controller, curve: Curves.easeInOut);
      animation = new Tween(begin: 0.0, end: widget.value).animate(curve)
        ..addListener(() {
          setState(() {});
        });

      controller.forward();
    } else {
      animation = AlwaysStoppedAnimation(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new CircularProgressIndicator(
      value: animation.value,
      valueColor: AlwaysStoppedAnimation(widget.color),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
