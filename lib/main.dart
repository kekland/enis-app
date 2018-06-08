import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:dynamic_theme/theme_switcher_widgets.dart';
import 'package:flutter/material.dart';

import 'classes/assessment.dart';
import 'pages/login_page.dart';
import 'widgets/imko/imko_subject_widget.dart';
import 'widgets/jko/jko_subject_widget.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
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
            '/main': (BuildContext context) => new TestPage(),
          },
        );
      },
    );
  }
}

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => new _TestPageState();
}

List<String> tabs = ['1 quarter', '2 quarter', '3 quarter', '4 quarter'];

class _TestPageState extends State<TestPage> {
  openBrightnessDialog(BuildContext ctx) {
    Brightness br = Theme.of(ctx).brightness;
    if (br == Brightness.dark)
      DynamicTheme.of(context).setBrightness(Brightness.light);
    else
      DynamicTheme.of(context).setBrightness(Brightness.dark);

  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 4,
      child: new Scaffold(
        appBar: AppBar(
          title: Text('eNIS'),
          bottom: TabBar(
            tabs: tabs.map((String tab) {
              return Tab(text: tab);
            }).toList(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_auto),
              onPressed: () => openBrightnessDialog(context),
            ),
          ],
        ),
        body: new Padding(
          padding: EdgeInsets.all(8.0),
          child: new Column(
            children: <Widget>[
              IMKOSubjectWidget(
                viewModel: new IMKOSubjectViewModel(
                  subjectName: 'Russian Language',
                  formative: new Assessment(
                    current: 3,
                    maximum: 5,
                  ),
                  summative: new Assessment(
                    current: 32,
                    maximum: 40,
                  ),
                ),
              ),
              IMKOSubjectWidget(
                viewModel: new IMKOSubjectViewModel(
                  subjectName: 'English',
                  formative: new Assessment(
                    current: 5,
                    maximum: 10,
                  ),
                  summative: new Assessment(
                    current: 23,
                    maximum: 24,
                  ),
                ),
              ),
              IMKOSubjectWidget(
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
              new JKOSubjectWidget(
                viewModel: new JKOSubjectViewModel(
                  percentage: 0.8399,
                  subjectName: 'English',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
