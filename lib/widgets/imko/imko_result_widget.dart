import 'package:flutter/material.dart';

class IMKOResultWidget extends StatefulWidget {
  @override
  _IMKOResultWidgetState createState() => _IMKOResultWidgetState();
}

class _IMKOResultWidgetState extends State<IMKOResultWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: new InkWell(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Text('hi'),
        ),
      ),
    );
  }
}
