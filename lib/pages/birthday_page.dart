import 'dart:async';

import 'package:enis_new/api/account_api.dart';
import 'package:enis_new/api/user_birthday_data.dart';
import 'package:enis_new/widgets/birthday/user_birthday_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

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
  applyQuery([String query]) {
    displayedData.clear();
    if (query != null || query.length == 0) {
      displayedData = data;
    } else {
      query = query.toLowerCase();
      for (UserBirthdayData dat in data) {
        String nameSurname = (dat.name + ' ' + dat.surname).toLowerCase();
        String surnameName = (dat.surname + ' ' + dat.name).toLowerCase();
        if (nameSurname.contains(query) || surnameName.contains(query) || birthdayToString(dat).contains(query)) {
          displayedData.add(dat);
        }
      }
      print(displayedData.length);
    }
  }

  SearchBar searchBar;
  _BirthdayPageState() {
    searchBar = new SearchBar(
      inBar: true,
      setState: setState,
      onChanged: (String query) => applyQuery(query),
      buildDefaultAppBar: buildAppBar,
    );
  }

  String birthdayToString(UserBirthdayData data) {
    return '${data.birthday.day}.${data.birthday.month}.${data.birthday.year}';
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: Text('Birthdays'),
      actions: [
        searchBar.getSearchAction(context),
      ],
    );
  }

  loadData() async {
    List loadedData = await AccountAPI.getBirthdays();
    displayedData = [];
    setState(() {
      data = loadedData;
      applyQuery('');
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (displayedData != null) {
      body = new Container(
        padding: const EdgeInsets.all(8.0),
        child: new ListView.builder(
          itemBuilder: ((BuildContext ctx, int index) {
            return new UserBirthdayWidget(data: displayedData[index]);
          }),
          itemCount: displayedData.length,
        ),
      );
    } else {
      body = new Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Birthdays'),
        bottom: AppBar(),
      ),
      body: body,
    );
  }
}
