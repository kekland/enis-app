import 'dart:async';

import '../../api/imko/imko_api.dart';
import '../../api/imko/imko_data.dart';
import 'imko_goal_widget.dart';
import 'imko_subject_widget.dart';
import 'package:flutter/material.dart';

class IMKOSubjectDetailPage extends StatefulWidget {
  final IMKOSubjectViewModel viewModel;
  IMKOSubjectDetailPage({this.viewModel});
  @override
  _IMKOSubjectDetailPageState createState() => _IMKOSubjectDetailPageState();
}

class _IMKOSubjectDetailPageState extends State<IMKOSubjectDetailPage> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  List<IMKOGoalGroup> goals;
  List<bool> expanded;

  initState() {
    super.initState();
    fetchGoals();
  }

  Future<Null> fetchGoals() async {
    try {
      dynamic d = await IMKODiaryAPI.getGoals(widget.viewModel.subject.quarter, widget.viewModel.subject.id);
      setState(() {
        goals = d;
        expanded = new List();
        goals.forEach((d) {
          expanded.add(true);
        });
      });
    } catch (e) {
      if (scaffoldKey.currentState != null) scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text('Error occurred while fetching goals')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: Text(widget.viewModel.subject.name),
      ),
      body: new SingleChildScrollView(
        child: new Padding(
          padding: EdgeInsets.all(16.0),
          child: new Column(
            children: [
              new Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: new IMKOSubjectWidget(
                  viewModel: widget.viewModel,
                  tappable: false,
                  animate: false,
                ),
              ),
              (goals == null)
                  ? new CircularProgressIndicator()
                  : new ExpansionPanelList(
                      expansionCallback: (int index, bool state) {
                        setState(() {
                          expanded[index] = !expanded[index];
                        });
                      },
                      children: goals.map((IMKOGoalGroup group) {
                        return new ExpansionPanel(
                          headerBuilder: (BuildContext context, bool isExpanded) {
                            return new Padding(
                              padding: EdgeInsets.all(16.0),
                              child: new Text(group.groupName),
                            );
                          },
                          body: new Column(
                            children: group.goals.map((IMKOGoal goal) {
                              return new IMKOGoalWidget(goal: goal);
                            }).toList(),
                          ),
                          isExpanded: expanded[goals.indexOf(group)],
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
