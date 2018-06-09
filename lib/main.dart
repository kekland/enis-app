import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:dynamic_theme/theme_switcher_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'classes/assessment.dart';
import 'global.dart';
import 'pages/calculator_page.dart';
import 'pages/grades_page.dart';
import 'pages/login_page.dart';
import 'pages/settings_page.dart';
import 'widgets/imko/imko_subject_widget.dart';
import 'widgets/jko/jko_subject_widget.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  loadGlobalsAsync() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Global.animate = prefs.getBool('animate');
    } catch (e) {
      Global.animate = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    MaterialPageRoute.debugEnableFadingRoutes = true;
    return new DynamicTheme(
      defaultBrightness: Brightness.dark,
      data: (brightness) => new ThemeData(
            brightness: brightness,
            primarySwatch: Colors.green,
            buttonColor: Colors.lightBlueAccent,
          ),
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp(
          title: 'eNIS',
          theme: theme,
          home: new LoginPage(),
          routes: {
            '/login': (BuildContext context) => new LoginPage(),
            '/main': (BuildContext context) => new GradesPage(),
            '/settings': (BuildContext context) => new SettingsPage(),
          },
        );
      },
    );
  }
}
