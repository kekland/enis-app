import 'dart:async';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/imko/imko_api.dart';
import '../api/quarter.dart';
import '../api/subject_data.dart';
import '../classes/assessment.dart';
import '../widgets/imko/imko_subject_widget.dart';
import '../widgets/jko/jko_subject_widget.dart';

class GradesPage extends StatefulWidget {
  @override
  _GradesPageState createState() => new _GradesPageState();
}

List<String> tabs = ['1 quarter', '2 quarter', '3 quarter', '4 quarter'];

class _GradesPageState extends State<GradesPage> {
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
        body: QuarterListWidget(),
      ),
    );
  }
}

class QuarterListWidget extends StatefulWidget {
  @override
  _QuarterListWidgetState createState() {
    _QuarterListWidgetState state = new _QuarterListWidgetState();
    state.fetchData();
    return state;
  }
}

SubjectData data = new SubjectData();

class _QuarterListWidgetState extends State<QuarterListWidget> {
  callbackDataRecieveHandler(int index, Quarter quarter) {
    setState(() {
      data.setQuarter(index, quarter);
    });
  }

  Future<Null> fetchData() async {
    setState(() {
      data = new SubjectData();
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int diaryType = prefs.getInt('diary_type');
    if (diaryType == 1) {
      IMKODiaryAPI.getAllImkoSubjectsCallback(callbackDataRecieveHandler);
      /*IMKODiaryAPI.getAllImkoSubjects().then((dynamic loadedData) {
        setState(() {
          data = loadedData;
        });
      }).catchError((error) {
        print(error);
      });*/
    } else {
      /*JKODiaryAPI.getStudentData().then((result) {
        print(result.studentID);
        print(result.classID);
      }).catchError((error) {
        print(error);
      });*/
    }
  }

  List quarters = [1, 2, 3, 4];
  @override
  Widget build(BuildContext context) {
    return new TabBarView(
      children: quarters
          .map(
            (quarter) => new QuarterWidget(
                  data: data.quarters[quarter - 1],
                  toRefresh: fetchData,
                ),
          )
          .toList(),
    );
  }
}

class QuarterWidget extends StatelessWidget {
  final Quarter data;
  final Function toRefresh;
  QuarterWidget({this.data, this.toRefresh});

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return new Center(child: new CircularProgressIndicator());
    } else {
      return new RefreshIndicator(
        child: new ListView.builder(
          padding: new EdgeInsets.all(8.0),
          itemCount: data.subjects.length,
          itemBuilder: (BuildContext context, int index) {
            return data.subjects[index].createWidget();
          },
        ),
        onRefresh: toRefresh,
      );
    }
  }
}
