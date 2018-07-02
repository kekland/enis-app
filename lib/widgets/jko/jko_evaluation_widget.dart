import 'package:enis_new/api/jko/jko_data.dart';
import 'package:enis_new/classes/assessment.dart';
import 'package:enis_new/global.dart';
import 'package:enis_new/widgets/assessment_number_widget.dart';
import 'package:flutter/material.dart';

class JKOEvaluationWidget extends StatelessWidget {
  final JKOAssessment data;
  final double animationValue;

  JKOEvaluationWidget({this.data, this.animationValue = 1.0});

  @override
  Widget build(BuildContext context) {
    return new Opacity(
      opacity: animationValue,
      child: new Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: new Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  data.description,
                  style: Theme.of(context).textTheme.body1.copyWith(
                        fontSize: 16.0,
                      ),
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new AssessmentCurrentMaximumWidget(
                    assessment: Assessment.lerp(data.topic, animationValue),
                    description: 'Topic',
                  ),
                  new AssessmentCurrentMaximumWidget(
                    assessment: Assessment.lerp(data.quarter, animationValue),
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