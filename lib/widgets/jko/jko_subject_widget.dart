import 'package:flutter/material.dart';

import '../../classes/assessment.dart';
import '../assessment_number_widget.dart';
import '../grade_widget.dart';

class JKOSubjectWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          new Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: new GradeWidget(
              viewModel: new GradeWidgetViewModel(
                grade: '5',
                gradeColor: Colors.green,
              ),
            ),
          ),
          new Expanded(
            child: Text(
              'English',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 17.0,
              ),
            ),
          ),
          new Row(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(left: 10.0, right: 5.0),
                child: new AssessmentPercentWidget(
                  new AssessmentPercentViewModel(
                    assessment: new Assessment(current: 80, maximum: 100),
                    description: 'Topic',
                    isColored: false,
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: new AssessmentPercentWidget(
                  new AssessmentPercentViewModel(
                    assessment: new Assessment(current: 85, maximum: 100),
                    description: 'Period',
                    isColored: false,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
