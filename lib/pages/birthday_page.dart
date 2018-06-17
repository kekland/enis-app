import 'dart:async';

import 'package:enis_new/api/account_api.dart';
import 'package:enis_new/api/user_birthday_data.dart';
import 'package:enis_new/widgets/birthday/user_birthday_widget.dart';
import 'package:flutter/material.dart';

class BirthdayPage extends StatefulWidget {
  @override
  _BirthdayPageState createState() {
    _BirthdayPageState state = new _BirthdayPageState();
    state.loadData();
    return state;
  }
}

List<UserBirthdayData> data;
List<UserBirthdayData> displayedData;
String query;

class _BirthdayPageState extends State<BirthdayPage> {
  loadData() async {
    List loadedData = await AccountAPI.getBirthdays();
    setState(() {
      data = loadedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (data != null) {
      body = new Container(
        padding: const EdgeInsets.all(8.0),
        child: new ListView.builder(
          itemBuilder: ((BuildContext ctx, int index) {
            return new UserBirthdayWidget(data: data[index]);
          }),
          itemCount: data.length,
        ),
      );
    } else {
      body = new Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Birthdays'),
      ),
      body: body,
    );
  }
}
