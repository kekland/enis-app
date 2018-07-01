import 'package:enis_new/api/jko/jko_data.dart';
import 'package:enis_new/classes/assessment.dart';
import 'package:enis_new/global.dart';
import 'package:enis_new/widgets/assessment_number_widget.dart';
import 'package:flutter/material.dart';

class JKOEvaluationViewModel {
  Assessment topicEvaluation;
  Assessment quarterEvaluation;

  String evaluationDescription;

  JKOEvaluationViewModel({this.evaluationDescription, this.topicEvaluation, this.quarterEvaluation});
}

class JKOEvaluationWidget extends StatefulWidget {
  final JKOAssessment data;

  JKOEvaluationWidget({this.data});
  @override
  _JKOEvaluationWidgetState createState() => _JKOEvaluationWidgetState();
}

class _JKOEvaluationWidgetState extends State<JKOEvaluationWidget> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();
    if (Global.animate) {
      controller = new AnimationController(duration: Duration(milliseconds: 1500), vsync: this);
      final CurvedAnimation curve = new CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
      animation = new Tween(begin: 0.0, end: 1.0).animate(curve)
        ..addListener(() {
          setState(() {});
        });

      controller.forward();
    } else {
      animation = AlwaysStoppedAnimation(1.0);
    }
  }

  @override
  void dispose() {
    if (controller != null) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Opacity(
      opacity: animation.value,
      child: new Card(
        child: new Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  widget.data.description,
                  style: Theme.of(context).textTheme.body1.copyWith(
                        fontSize: 16.0,
                      ),
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new AssessmentCurrentMaximumWidget(
                    assessment: Assessment.lerp(widget.data.topic, animation.value),
                    description: 'Topic',
                  ),
                  new AssessmentCurrentMaximumWidget(
                    assessment: Assessment.lerp(widget.data.quarter, animation.value),
                    description: 'Quarter',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
