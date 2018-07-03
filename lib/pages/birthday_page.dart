import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:enis_new/api/account_api.dart';
import 'package:enis_new/api/user_birthday_data.dart';
import 'package:enis_new/classes/birthday_utils.dart';
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

class _BirthdayPageState extends State<BirthdayPage> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  String query;

  Duration duration = Duration(milliseconds: 500);
  initState() {
    super.initState();
    controller = new AnimationController(duration: duration, vsync: this);
    final CurvedAnimation curve = new CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    animation = new Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  dispose() {
    super.dispose();
    if (controller != null) controller.dispose();
    if (animation != null) {}
  }

  applyQuery() {
    List<UserBirthdayData> dataToSet = [];
    if (query == null || query.length == 0) {
      dataToSet = data;
    } else {
      query = query.toLowerCase();
      for (UserBirthdayData dat in data) {
        String nameSurname = (dat.name + ' ' + dat.surname).toLowerCase();
        String surnameName = (dat.surname + ' ' + dat.name).toLowerCase();
        String role = (dat.role).toLowerCase();
        if (nameSurname.contains(query) || surnameName.contains(query) || BirthdayUtils.birthdayToString(dat).contains(query) || role.contains(query)) {
          dataToSet.add(dat);
        }
      }
    }
    setState(() => displayedData = dataToSet);
  }

  bool errorOccurredReload = false;
  loadData() async {
    controller.reverse();
    new Future.delayed(duration, () async {
      setState(() {
        data = null;
        displayedData = null;
      });
      try {
        List loadedData = await AccountAPI.getBirthdays();
        displayedData = [];
        if (mounted) {
          controller.forward();
          setState(() {
            data = loadedData;
            applyQuery();
          });
        }
      } catch (error) {
        if (scaffoldKey != null && mounted) {
          scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text(error.message)));
          setState(() {
            errorOccurredReload = true;
          });
        }
      }
    });
  }

  Future<Null> refresh() async {
    setState(() {
      errorOccurredReload = false;
    });
    await loadData();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (errorOccurredReload) {
      body = new Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              iconSize: 36.0,
              icon: Icon(Icons.refresh),
              onPressed: refresh,
            ),
            Text(
              'Something went wrong. Click button above to refresh',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );
    } else if (displayedData != null && displayedData.length != 0) {
      body = new RefreshIndicator(
        onRefresh: refresh,
        child: new Opacity(
          opacity: animation.value,
          child: new ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemBuilder: ((BuildContext ctx, int index) {
              return new UserBirthdayWidget(data: displayedData[index]);
            }),
            itemCount: displayedData.length,
          ),
        ),
      );
    } else {
      body = new Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Birthdays'),
        bottom: PreferredSize(
          preferredSize: new Size.fromHeight(56.0),
          child: new Container(
            height: 56.0,
            alignment: Alignment.center,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(28.0))),
              elevation: 8.0,
              margin: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                top: 6.0,
                bottom: 6.0,
              ),
              child: new Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                child: TextField(
                  onChanged: (String s) {
                    query = s;
                    applyQuery();
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                    hintText: 'Search',
                    isDense: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: body,
    );
  }
}
