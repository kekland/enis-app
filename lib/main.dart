import 'package:flutter/material.dart';

import 'widgets/imko_subject_widget.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: new TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => new _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('eNIS')),
      body: new Padding(
        padding: EdgeInsets.all(8.0),
        child: IMKOSubjectWidget(),
      ),
    );
  }
}
