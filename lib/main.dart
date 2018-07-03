
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:enis_new/pages/login_page.dart';
import 'package:enis_new/pages/main_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            accentColor: Colors.greenAccent,
          ),
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp(
          title: 'eNIS',
          theme: theme,
          home: new MainPage(),
          routes: {
            '/login': (BuildContext context) => new LoginPage(),
            '/main': (BuildContext context) => new MainPage(),
          },
        );
      },
    );
  }
}
