import 'dart:async';

import 'package:enis_new/api/jko/jko_api.dart';
import 'package:enis_new/api/jko/jko_data.dart';
import 'package:enis_new/widgets/jko/jko_evaluation_widget.dart';
import 'package:enis_new/widgets/jko/jko_subject_widget.dart';
import 'package:flutter/material.dart';

class JKOSubjectDetailPage extends StatefulWidget {
  final JKOSubject subject;

  JKOSubjectDetailPage({this.subject});
  @override
  _JKOSubjectDetailPageState createState() => _JKOSubjectDetailPageState();
}

class _JKOSubjectDetailPageState extends State<JKOSubjectDetailPage> with SingleTickerProviderStateMixin {
  List<JKOAssessment> evaluationModels;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();
    fetchGoals();
    controller = new AnimationController(duration: Duration(milliseconds: 1500), vsync: this);
    final CurvedAnimation curve = new CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    animation = new Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  Future<Null> fetchGoals() async {
    try {
      evaluationModels = await JKODiaryAPI.getAssessments(widget.subject);
      setState(() {
        if (controller != null) controller.forward();
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
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(widget.subject.name, style: Theme.of(context).textTheme.title.copyWith(fontFamily: 'Futura', color: Colors.black)),
      ),
      body: new SingleChildScrollView(
        child: new Padding(
          padding: EdgeInsets.all(16.0),
          child: new Column(
            children: [
              new Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: new JKOSubjectWidget(
                  subject: widget.subject,
                  tappable: false,
                ),
              ),
              (evaluationModels == null)
                  ? new CircularProgressIndicator()
                  : new Column(
                      children: evaluationModels.map((JKOAssessment assessment) {
                        return JKOEvaluationWidget(
                          data: assessment,
                          animationValue: animation.value,
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
