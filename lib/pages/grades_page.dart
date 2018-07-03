import 'dart:async';

import 'package:enis_new/api/imko/imko_api.dart';
import 'package:enis_new/api/imko/imko_data.dart';
import 'package:enis_new/api/jko/jko_api.dart';
import 'package:enis_new/api/quarter.dart';
import 'package:enis_new/api/subject.dart';
import 'package:enis_new/api/subject_data.dart';
import 'package:enis_new/widgets/imko/imko_result_widget.dart';
import 'package:enis_new/widgets/imko/imko_subject_widget.dart';
import 'package:enis_new/widgets/jko/jko_subject_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GradesPage extends StatefulWidget {
  @override
  _GradesPageState createState() => new _GradesPageState();
}

List<String> tabs = ['Term 1', 'Term 2', 'Term 3', 'Term 4'];
//List<String> tabs = ['Term 1', 'Term 2', 'Term 3', 'Term 4', 'Results'];

class _GradesPageState extends State<GradesPage> {
  @override
  Widget build(BuildContext context) {
    return QuarterListWidget();
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

class _QuarterListWidgetState extends State<QuarterListWidget> with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  bool errorOccurredReload = false;
  double loadPercentage = 0.0;
  initState() {
    super.initState();
    controller = new AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    controller
      ..addListener(() {
        setState(() {});
      });
  }

  callbackDataRecieveHandler(int index, Quarter quarter) {
    if (mounted) {
      setState(() {
        data.setQuarter(index, quarter);
        loadPercentage += 0.25;
        if (loadPercentage == 1.0) {
          controller.forward();
        }
      });
    }
  }

  Future<Null> fetchData() async {
    controller.reverse();
    new Future.delayed(Duration(milliseconds: 1000), () async {
      if (mounted) {
        setState(() {
          data = new SubjectData();
        });

        loadPercentage = 0.0;
        errorOccurredReload = false;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int diaryType = prefs.getInt('diary_type');
        if (diaryType == 1) {
          IMKODiaryAPI.getAllImkoSubjectsCallback(callbackDataRecieveHandler).catchError((e) {
            if (Scaffold.of(context) != null && mounted) {
              Scaffold.of(context).showSnackBar(new SnackBar(content: Text(e.message)));
              setState(() {
                errorOccurredReload = true;
              });
            }
          });
        } else {
          JKODiaryAPI.getAllJkoSubjectsCallback(callbackDataRecieveHandler).catchError((e) {
            if (Scaffold.of(context) != null && mounted) {
              Scaffold.of(context).showSnackBar(new SnackBar(content: Text(e.message)));
              setState(() {
                errorOccurredReload = true;
              });
            }
          });
        }
      }
    });
  }

  List quarters = [1, 2, 3, 4];
  @override
  Widget build(BuildContext context) {
    List quarterWidgets = quarters
        .map(
          (quarter) => new QuarterWidget(
                quarterIndex: quarter - 1,
                data: data.quarters[quarter - 1],
                toRefresh: fetchData,
                errorOccurredReload: errorOccurredReload,
                animationValue: animation.value,
                loadPercentage: loadPercentage,
              ),
        )
        .whereType<Widget>()
        .toList();

    //quarterWidgets.add(ResultsWidget());
    return new TabBarView(
      children: quarterWidgets,
    );
  }
}

class QuarterWidget extends StatelessWidget {
  final int quarterIndex;
  final Quarter data;
  final Function toRefresh;
  final bool errorOccurredReload;
  final double loadPercentage;
  final double animationValue;

  QuarterWidget({this.quarterIndex, this.data, this.toRefresh, this.loadPercentage, this.animationValue, this.errorOccurredReload = false});

  @override
  Widget build(BuildContext context) {
    if (errorOccurredReload) {
      return new Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              iconSize: 36.0,
              icon: Icon(Icons.refresh),
              onPressed: toRefresh,
            ),
            Text(
              'Something went wrong. Click button above to refresh',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );
    } else if (data == null || loadPercentage != 1.0) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new RefreshIndicator(
        child: new Opacity(
          opacity: animationValue,
          child: new ListView.builder(
            padding: new EdgeInsets.all(8.0),
            itemCount: data.subjects.length,
            itemBuilder: (BuildContext context, int index) {
              Subject subject = data.subjects[index];
              if (subject is IMKOSubject) {
                return Padding(
                  padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: IMKOSubjectWidget(
                    subject: subject,
                    animationValue: animationValue,
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: JKOSubjectWidget(
                    subject: subject,
                    animationValue: animationValue,
                  ),
                );
              }
            },
          ),
        ),
        onRefresh: toRefresh,
      );
    }
  }
}

class ResultsWidget extends StatefulWidget {
  @override
  _ResultsWidgetState createState() => _ResultsWidgetState();
}

class _ResultsWidgetState extends State<ResultsWidget> {
  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return new Center(child: new CircularProgressIndicator());
    } else {
      return ListView.builder(
        padding: new EdgeInsets.all(8.0),
        itemCount: data.quarters[0].subjects.length,
        itemBuilder: (BuildContext context, int index) {
          if (data.quarters[0].subjects[0].runtimeType == IMKOSubject) {
            return IMKOResultWidget(
              subjects: data.quarters.map((Quarter q) => q.subjects[index]).cast<IMKOSubject>().toList(),
            );
          }
        },
      );
    }
  }
}
