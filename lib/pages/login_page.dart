import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/account_api.dart';
import '../api/user_data.dart';
import '../classes/school.dart';
import '../widgets/loading_dialog.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool debuggingWithMyAccount = true;
  String submittedSchool, submittedPIN, submittedPassword;
  AnimationController controller;
  Animation<double> animation;

  login(BuildContext ctx) {
    UnknownUserData userData = new UnknownUserData(
      pin: submittedPIN,
      password: submittedPassword,
      schoolURL: submittedSchool,
    );

    if (debuggingWithMyAccount) {
      userData.pin = '020917501426';
      userData.password = 'Almaty98';

      /*
      userData.pin = '021107501405'
      userData.password = 'TestPassword';*/
      userData.schoolURL = 'http://fmalm.nis.edu.kz/Almaty_Fmsh';
    }

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: ((BuildContext ctx) {
        return new LoadingDialogWidget('Logging in');
      }),
    );

    AccountAPI.login(userData).then((UserData data) {
      Navigator.pop(ctx);
      print(json.encode(data.toJSON()));
      showDialog(
        context: ctx,
        barrierDismissible: true,
        builder: ((BuildContext ctx) {
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
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pushReplacementNamed('/main');
                  },
                ),
                FlatButton(
                  child: Text('JKO'),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setInt('diary_type', 2);
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pushReplacementNamed('/main');
                  },
                ),
              ],
            ),
          );
        }),
      );
    }).catchError((e) {
      print(e);
      Navigator.pop(ctx);
      scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text('${e.message}')));
    });
    //Navigator.of(ctx).pushReplacementNamed('/main');
  }

  initState() {
    super.initState();
    controller = new AnimationController(duration: Duration(milliseconds: 1500), vsync: this);
    final CurvedAnimation curve = new CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    animation = new Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      body: new Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: const Alignment(-1.0, -1.0),
            end: const Alignment(1.5, 1.5),
            colors: <Color>[Colors.lightBlueAccent.withOpacity(animation.value), Colors.greenAccent],
          ),
        ),
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new Container(
                child: new Center(
                  child: new Transform(
                    transform: new Matrix4.translationValues(0.0, -100.0 * (1.0 - animation.value), 0.0),
                    child: new Image.asset(
                      'assets/nis_logo.png',
                      width: 240.0,
                      height: 240.0,
                      color: Colors.white.withOpacity(animation.value),
                    ),
                  ),
                ),
              ),
            ),
            new Container(
              color: Theme.of(context).dialogBackgroundColor.withOpacity(animation.value),
              padding: new EdgeInsets.all(32.0),
              child: new Opacity(
                opacity: animation.value,
                child: new Transform(
                  transform: new Matrix4.translationValues(0.0, 100.0 * (1.0 - animation.value), 0.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Text(
                        'eNIS',
                        textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 32.0),
                      ),
                      new TextField(
                        decoration: new InputDecoration(
                          labelText: 'PIN',
                          icon: new Icon(Icons.person),
                        ),
                        maxLength: 12,
                        maxLengthEnforced: true,
                        keyboardType: TextInputType.number,
                        onChanged: (s) => submittedPIN = s,
                      ),
                      new TextField(
                        decoration: new InputDecoration(
                          labelText: 'Password',
                          icon: new Icon(Icons.lock),
                        ),
                        obscureText: true,
                        onChanged: (s) => submittedPassword = s,
                      ),
                      new Padding(
                        child: new Center(
                          child: new DropdownButton(
                            items: School.schools.entries.map((MapEntry<String, String> entry) {
                              return new DropdownMenuItem(
                                child: new Text(entry.key),
                                value: entry.value,
                              );
                            }).toList(),
                            value: submittedSchool,
                            onChanged: (String selected) {
                              setState(() {
                                submittedSchool = selected;
                              });
                            },
                            hint: new Text('School'),
                          ),
                        ),
                        padding: new EdgeInsets.all(8.0),
                      ),
                      new RaisedButton(
                        child: new Text(
                          'Login',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () => login(context),
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
