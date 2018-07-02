
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
      defaultBrightness: Brightness.dark,
      data: (brightness) => new ThemeData(
            brightness: brightness,
            primarySwatch: Colors.green,
            buttonColor: Colors.lightBlueAccent,
            bottomAppBarColor: Colors.white,
          ),
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp(
          title: 'eNIS',
          theme: theme,
        );
      },
    );
  }
}
