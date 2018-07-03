import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool switchState = true;
  bool darkState = false;

  @override
  initState() {
    super.initState();
    loadStates();
  }

  void loadStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getBool('animate') == null) {
        prefs.setBool('animate', true);
      }
      switchState = prefs.getBool('animate');
      if (prefs.getBool('dark') == null) {
        prefs.setBool('dark', false);
      }
      darkState = prefs.getBool('dark');
    });
  }

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
    //Navigator.of(context).popUntil((Route<dynamic> route) => false);
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

    //Global.router.navigateTo(context, Routes.login);
  }

  void darkSwitchTapped(bool state, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('dark', state);
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
    return new Padding(
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
            padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.brightness_6),
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
    );
  }
}
