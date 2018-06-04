import 'package:flutter/material.dart';

import 'classes/assessment.dart';
import 'widgets/imko_subject_widget.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'eNIS',
      theme: new ThemeData(
        primarySwatch: Colors.green,
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
        child: IMKOSubjectWidget(
          viewModel: new IMKOSubjectViewModel(
            subjectName: 'Kazakhstan in Modern World',
            formative: new Assessment(
              current: 9,
              maximum: 10,
            ),
            summative: new Assessment(
              current: 40,
              maximum: 40,
            ),
          ),
        ),
      ),
    );
  }
}
