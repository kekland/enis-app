import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool switchState = true;
  bool darkState = false;

  void diarySelectionTapped(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: ((BuildContext context) {
          return new AlertDialog(
            title: Text('Select diary type'),
            content: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  child: Text('IMKO'),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setInt('diary_type', 1);
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('JKO'),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setInt('diary_type', 2);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }));
  }

  void logoutTapped(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('user_log_in_at_next_time', false);
    Navigator.of(context).pop();
    Navigator.of(context).popAndPushNamed('/login');
  }

  void animationSwitchTapped(bool state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('animate', state);
    Global.animate = state;
    setState(() {
      switchState = state;
    });
  }

  void darkSwitchTapped(bool state, BuildContext context) async {
    if (state)
      DynamicTheme.of(context).setBrightness(Brightness.dark);
    else
      DynamicTheme.of(context).setBrightness(Brightness.light);
    setState(() {
      darkState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            new InkWell(
              onTap: () => diarySelectionTapped(context),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(Icons.book),
                  ),
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Select diary type',
                        style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(Icons.offline_bolt),
                  ),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Animations',
                          style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16.0),
                        ),
                        Text(
                          'Turn animations off if you are having performance issues',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  new Switch(
                    value: switchState,
                    onChanged: (bool a) => animationSwitchTapped(a),
                  )
                ],
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(Icons.offline_bolt),
                  ),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Dark theme',
                          style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16.0),
                        ),
                        Text(
                          'Dark theme helps to reduce eye strain',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  new Switch(
                    value: darkState,
                    onChanged: (bool a) => darkSwitchTapped(a, context),
                  )
                ],
              ),
            ),
            new InkWell(
              onTap: () => logoutTapped(context),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(Icons.account_box),
                  ),
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Log out',
                        style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16.0),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
