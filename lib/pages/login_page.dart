import 'package:flutter/material.dart';

import '../classes/school.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  String submittedSchool, submittedPIN, submittedPassword;
  AnimationController controller;
  Animation<double> animation;

  login(BuildContext ctx) {
    Navigator.of(ctx).pushReplacementNamed('/main');
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
                        child: new Text('Login', style: TextStyle(color: Colors.black),),
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
