import 'dart:async';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:enis_new/api/imko/imko_api.dart';
import 'package:enis_new/api/imko/imko_data.dart';
import 'package:enis_new/api/jko/jko_api.dart';
import 'package:enis_new/api/quarter.dart';
import 'package:enis_new/api/subject_data.dart';
import 'package:enis_new/global.dart';
import 'package:enis_new/widgets/imko/imko_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GradesPage extends StatefulWidget {
  @override
  _GradesPageState createState() => new _GradesPageState();
}

List<String> tabs = ['Term 1', 'Term 2', 'Term 3', 'Term 4'];
//List<String> tabs = ['Term 1', 'Term 2', 'Term 3', 'Term 4', 'Results'];

class _GradesPageState extends State<GradesPage> {
  openBrightnessDialog(BuildContext ctx) {
    Brightness br = Theme.of(ctx).brightness;
    if (br == Brightness.dark)
      DynamicTheme.of(context).setBrightness(Brightness.light);
    else
      DynamicTheme.of(context).setBrightness(Brightness.dark);
  }

  openSettingsPage(BuildContext ctx) {
    Navigator.of(ctx).pushNamed('/settings');
  }

  openCalculatorPage(BuildContext ctx) {
    Navigator.of(ctx).pushNamed('/calculator');
  }

  openBirthdayPage(BuildContext ctx) {
    Navigator.of(ctx).pushNamed('/birthday');
  }

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 4,
      //length: 5,
      child: new Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('eNIS', style: Theme.of(context).textTheme.title.copyWith(fontFamily: 'Futura', color: Colors.white)),
          bottom: TabBar(
            tabs: tabs.map((String tab) {
              return Tab(text: tab);
            }).toList(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.assessment),
              onPressed: () => openCalculatorPage(context),
            ),
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () => openBirthdayPage(context),
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => openSettingsPage(context),
            ),
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

class _QuarterListWidgetState extends State<QuarterListWidget> with SingleTickerProviderStateMixin {
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

    //quarterWidgets.add(ResultsWidget());
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
  Animation<double> animation;
  AnimationController controller;

  Duration duration = Duration(milliseconds: 500);
  initState() {
    super.initState();
    if (Global.animate) {
      controller = new AnimationController(duration: duration, vsync: this);
      final CurvedAnimation curve = new CurvedAnimation(parent: controller, curve: Curves.easeInOut);
      animation = new Tween(begin: 0.0, end: 1.0).animate(curve)
        ..addListener(() {
          if (mounted) {
            setState(() {});
          }
        });
    } else {
      animation = AlwaysStoppedAnimation(1.0);
    }
  }

  @override
  dispose() {
    super.dispose();
    if (controller != null) controller.dispose();
    if (animation != null) {}
  }

  bool showForward = true;
  Future<Null> onRefresh() async {
    if (!mounted) {
      return;
    }
    if (Global.animate) {
      controller.reverse(from: 1.0);
      new Future.delayed(duration, () => widget.toRefresh());
    } else {
      widget.toRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.errorOccurredReload) {
      showForward = true;
      return new Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              iconSize: 36.0,
              icon: Icon(Icons.refresh),
              onPressed: onRefresh,
            ),
            Text(
              'Something went wrong. Click button above to refresh',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );
    } else if (widget.data == null) {
      showForward = true;
      return new Center(child: new CircularProgressIndicator());
    } else {
      if (showForward) {
        controller.forward();
        showForward = false;
      }
      return new RefreshIndicator(
        child: new Opacity(
          opacity: animation.value,
          child: new ListView.builder(
            padding: new EdgeInsets.all(8.0),
            itemCount: widget.data.subjects.length,
            itemBuilder: (BuildContext context, int index) {
              Widget w = widget.data.subjects[index].createWidget(animation);
              return Padding(padding: EdgeInsets.only(top: 4.0, bottom: 4.0), child: w);
            },
          ),
        ),
        onRefresh: onRefresh,
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
