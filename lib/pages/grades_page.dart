import 'dart:async';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/imko/imko_api.dart';
import '../api/imko/imko_data.dart';
import '../api/jko/jko_api.dart';
import '../api/quarter.dart';
import '../api/subject.dart';
import '../api/subject_data.dart';
import '../classes/assessment.dart';
import '../global.dart';
import '../widgets/imko/imko_subject_widget.dart';
import '../widgets/jko/jko_subject_widget.dart';
import 'calculator_page.dart';

class GradesPage extends StatefulWidget {
  @override
  _GradesPageState createState() => new _GradesPageState();
}

List<String> tabs = ['Term 1', 'Term 2', 'Term 3', 'Term 4', 'Results'];

class _GradesPageState extends State<GradesPage> {
  openBrightnessDialog(BuildContext ctx) {
    Brightness br = Theme.of(ctx).brightness;
    if (br == Brightness.dark)
      DynamicTheme.of(context).setBrightness(Brightness.light);
    else
      DynamicTheme.of(context).setBrightness(Brightness.dark);
  }

  openSettings(BuildContext ctx) {
    Navigator.of(ctx).pushNamed('/settings');
  }

  openCalculator(BuildContext ctx) {
    Navigator.of(ctx).pushNamed('/calculator');
  }

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 5,
      child: new Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('eNIS'),
          bottom: TabBar(
            tabs: tabs.map((String tab) {
              return Tab(text: tab);
            }).toList(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => openSettings(context),
            ),
            IconButton(
              icon: Icon(Icons.assessment),
              onPressed: () => openCalculator(context),
            )
          ],
        ),
        body: QuarterListWidget(scaffoldKey: scaffoldKey),
      ),
    );
  }
}

class QuarterListWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  QuarterListWidget({this.scaffoldKey});
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
    if (mounted) {
      setState(() {
        data.setQuarter(index, quarter);
      });
    }
  }

  Future<Null> updateQuarter(int index) async {}

  bool errorOccurredReload = false;
  Future<Null> fetchData() async {
    if (mounted) {
      setState(() {
        data = new SubjectData();
      });

      errorOccurredReload = false;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int diaryType = prefs.getInt('diary_type');
      if (diaryType == 1) {
        IMKODiaryAPI.getAllImkoSubjectsCallback(callbackDataRecieveHandler).catchError((e) {
          if (widget.scaffoldKey != null && mounted) {
            widget.scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text(e.message)));
            setState(() {
              errorOccurredReload = true;
            });
          }
        });
        /*IMKODiaryAPI.getAllImkoSubjects().then((dynamic loadedData) {
        setState(() {
          data = loadedData;
        });
      }).catchError((error) {
        print(error);
      });*/
      } else {
        JKODiaryAPI.getAllJkoSubjectsCallback(callbackDataRecieveHandler).catchError((e) {
          if (widget.scaffoldKey != null && mounted) {
            widget.scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text(e.message)));
            setState(() {
              errorOccurredReload = true;
            });
          }
        });
      }
    }
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
              ),
        )
        .whereType<Widget>()
        .toList();

    quarterWidgets.add(
      Container(
        child: CircularProgressIndicator(),
      ),
    );
    return new TabBarView(
      children: quarterWidgets,
    );
  }
}

class QuarterWidget extends StatefulWidget {
  final int quarterIndex;
  final Quarter data;
  final Function toRefresh;
  final bool errorOccurredReload;

  QuarterWidget({this.quarterIndex, this.data, this.toRefresh, this.errorOccurredReload = false});
  @override
  _QuarterWidgetState createState() => _QuarterWidgetState();
}

class _QuarterWidgetState extends State<QuarterWidget> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation = AlwaysStoppedAnimation(1.0);

  Future<Null> onRefresh() async {
    if (!mounted) {
      return;
    }
    if (Global.animate) {
      controller = new AnimationController(duration: Duration(milliseconds: 500), vsync: this);
      final CurvedAnimation curve = new CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
      animation = new Tween(begin: 1.0, end: 0.0).animate(curve)
        ..addListener(() {
          setState(() {});
        })
        ..addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            animation = AlwaysStoppedAnimation(1.0);
            widget.toRefresh();
          }
        });

      controller.forward();
    } else {
      widget.toRefresh();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (controller != null) controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.errorOccurredReload) {
      return new Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              iconSize: 36.0,
              icon: Icon(Icons.refresh),
              onPressed: widget.toRefresh,
            ),
            Text(
              'Something went wrong. Click button above to refresh',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );
    } else if (widget.data == null) {
      return new Center(child: new CircularProgressIndicator());
    } else {
      return new RefreshIndicator(
        child: new Opacity(
          opacity: animation.value,
          child: new ListView.builder(
            padding: new EdgeInsets.all(8.0),
            itemCount: widget.data.subjects.length,
            itemBuilder: (BuildContext context, int index) {
              Widget w = widget.data.subjects[index].createWidget();
              widget.data.subjects[index].alreadyAnimated = true;
              data.quarters[widget.quarterIndex].subjects[index].alreadyAnimated = true;
              return Padding(padding: EdgeInsets.only(top: 4.0, bottom: 4.0), child: w);
            },
          ),
        ),
        onRefresh: onRefresh,
      );
    }
  }
}
