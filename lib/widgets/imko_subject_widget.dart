import 'package:flutter/material.dart';

import 'assessment_number_widget.dart';

class IMKOSubjectWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Card(
        child: Container(
      padding: EdgeInsets.all(16.0),
      child: new AssessmentPercentWidget(
        new AssessmentPercentViewModel(
          assessmentCurrent: 6,
          assessmentMaximum: 8,
          description: 'FA',
        ),
      ),
    ),);
  }
}
