import '../../widgets/assessment_number_widget.dart';
import 'package:flutter/material.dart';

import '../../classes/assessment.dart';

class JKOEvaluationViewModel {
  Assessment topicEvaluation;
  Assessment quarterEvaluation;

  String evaluationDescription;

  JKOEvaluationViewModel({this.evaluationDescription, this.topicEvaluation, this.quarterEvaluation});
}

class JKOEvaluationWidget extends StatelessWidget {
  final JKOEvaluationViewModel viewModel;

  JKOEvaluationWidget({this.viewModel});
  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Maecenas a congue odio, vitae aliquam augue',
                style: Theme.of(context).textTheme.body1.copyWith(
                      fontSize: 16.0,
                    ),
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new AssessmentCurrentMaximumWidget(
                  new AssessmentCurrentMaximumViewModel(
                      assessment: new Assessment(
                        current: 14,
                        maximum: 20,
                      ),
                      description: 'Topic'),
                ),
                new AssessmentCurrentMaximumWidget(
                  new AssessmentCurrentMaximumViewModel(
                      assessment: new Assessment(
                        current: 16,
                        maximum: 20,
                      ),
                      description: 'Quarter'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
