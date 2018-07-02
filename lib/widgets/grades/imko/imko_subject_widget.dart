import 'package:enis_new/api/imko/imko_data.dart';
import 'package:enis_new/widgets/grades/assessment_number_widget.dart';
import 'package:flutter/material.dart';

class IMKOSubjectWidget extends StatelessWidget {
  final IMKOSubject subject;
  final double animationValue;
  IMKOSubjectWidget({this.subject, this.animationValue = 1.0});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      subject.name,
                      style: Theme.of(context).textTheme.body1.copyWith(fontSize: 20.0, fontFamily: 'Futura', fontWeight: FontWeight.w500),
                    ),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: new AssessmentCurrentMaximumWidget(
                          assessment: subject.formative,
                          animationValue: animationValue,
                          description: 'FA',
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: new AssessmentCurrentMaximumWidget(
                          assessment: subject.summative,
                          animationValue: animationValue,
                          description: 'SA',
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(left: 8.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ClipPath(
            child: Container(
              width: 64.0,
              height: (subject.calculateGradePercentage() * 113.0),
              color: subject.calculateGradeColor(),
            ),
          ),
        ],
      ),
    );
  }
}
