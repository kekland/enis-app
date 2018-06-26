import 'dart:async';

import 'package:enis_new/api/jko/jko_api.dart';
import 'package:enis_new/api/jko/jko_data.dart';
import 'package:enis_new/widgets/jko/jko_evaluation_widget.dart';
import 'package:enis_new/widgets/jko/jko_subject_widget.dart';
import 'package:flutter/material.dart';


class JKOSubjectDetailPage extends StatefulWidget {
  final JKOSubjectViewModel viewModel;

  JKOSubjectDetailPage({this.viewModel});
  @override
  _JKOSubjectDetailPageState createState() => _JKOSubjectDetailPageState();
}

class _JKOSubjectDetailPageState extends State<JKOSubjectDetailPage> {
  List<JKOAssessment> evaluationModels;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  initState() {
    super.initState();
    fetchGoals();
  }

  Future<Null> fetchGoals() async {
    try {
      evaluationModels = await JKODiaryAPI.getAssessments(widget.viewModel.subject);
      setState(() {});
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
                child: new JKOSubjectWidget(
                  viewModel: widget.viewModel,
                  tappable: false,
                ),
              ),
              (evaluationModels == null)
                  ? new CircularProgressIndicator()
                  : new Column(
                      children: evaluationModels.map((JKOAssessment assessment) {
                        return JKOEvaluationWidget(data: assessment);
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
