import 'package:flutter/material.dart';

import 'assessment_number_widget.dart';
import '../classes/assessment.dart';

class IMKOSubjectViewModel {
  String subjectName;
  Assessment formative;
  Assessment summative;

  IMKOSubjectViewModel({this.subjectName, this.formative, this.summative});
}

class IMKOSubjectWidget extends StatelessWidget {
  IMKOSubjectViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('English', style: TextStyle(color: Colors.black87, fontSize: 18.0)),
            new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 5.0),
                  child: new AssessmentPercentWidget(
                    new AssessmentPercentViewModel(
                      assessmentCurrent: 7,
                      assessmentMaximum: 8,
                      description: 'FA',
                      isColored: true,
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  child: new AssessmentPercentWidget(
                    new AssessmentPercentViewModel(
                      assessmentCurrent: 31,
                      assessmentMaximum: 40,
                      description: 'SA',
                      isColored: true,
                    ),
                  ),
                ),
                new Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: new Text(
                      'A+',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                        fontSize: 40.0,
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
