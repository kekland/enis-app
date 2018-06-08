import 'dart:async';

import '../../api/imko/imko_api.dart';
import '../../api/imko/imko_data.dart';
import 'package:flutter/material.dart';

import '../../api/jko/jko_api.dart';
import '../../api/jko/jko_data.dart';
import 'jko_evaluation_widget.dart';
import 'jko_subject_widget.dart';

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
      scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text('Error occurred while fetching goals')));
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
                  animate: false,
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
