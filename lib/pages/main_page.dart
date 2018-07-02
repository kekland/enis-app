import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
          title: Text('eNIS', style: Theme.of(context).textTheme.title.copyWith(fontFamily: 'Futura', color: Colors.black)),
      ),
    );
  }
}