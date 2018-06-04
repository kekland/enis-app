import 'package:flutter/material.dart';

import '../classes/diary.dart';
import '../classes/grade.dart';
import 'assessment_number_widget.dart';
import '../classes/assessment.dart';

class IMKOSubjectViewModel {
  String subjectName;
  Assessment formative;
  Assessment summative;

  double calculateGradePercentage() {
    double percentage;
    if(summative.maximum == 0) {
      percentage = formative.getPercentage() * 60.0;
    }
    else {
      percentage = formative.getPercentage() * 18.0 + summative.getPercentage() * 42.0;
    }
    percentage /= 60.0;
    return percentage;
  }

  String calculateGrade() {
    double percentage = calculateGradePercentage();
    return Grade.calculateGrade(percentage, Diary.imko);
  }

  Color calculateGradeColor() {
    String numericGrade = Grade.toNumericalGrade(calculateGrade());
    switch (numericGrade) {
      case '5':
        return Colors.green;
      case '4':
        return Colors.amber;
      case '3':
        return Colors.deepOrange;
      case '2':
        return Colors.red;
      default:
      return
      default:
    }
  }

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
