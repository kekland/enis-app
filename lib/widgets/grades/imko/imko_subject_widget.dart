import 'package:enis_new/api/imko/imko_data.dart';
import 'package:enis_new/widgets/grades/assessment_number_widget.dart';
import 'package:enis_new/widgets/grades/wavy_grade_widget.dart';
import 'package:flutter/material.dart';

class IMKOSubjectWidget extends StatelessWidget {
  final IMKOSubject subject;
  final double animationValue;
  IMKOSubjectWidget({this.subject, this.animationValue = 1.0});
  @override
  Widget build(BuildContext context) {
    double animationValueDoubled = (animationValue * 2 > 1.0)? 1.0 : animationValue * 2.0;
    return Opacity(
      opacity: animationValueDoubled,
      child: Card(
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
                    Text(
                      subject.name,
                      style: Theme.of(context).textTheme.body1.copyWith(fontSize: 20.0, fontFamily: 'Futura', fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8.0),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new AssessmentCurrentMaximumWidget(
                          assessment: subject.formative,
                          animationValue: animationValue,
                          description: 'FA',
                        ),
                        SizedBox(width: 16.0),
                        new AssessmentCurrentMaximumWidget(
                          assessment: subject.summative,
                          animationValue: animationValue,
                          description: 'SA',
                        ),
                        SizedBox(width: 16.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            WavyGradeWidget(
              color: subject.calculateGradeColor(),
              percentage: subject.calculateGradePercentage(),
              maxHeight: 113.0,
              animationValue: animationValue,
              grade: subject.calculateGrade(),
            )
          ],
        ),
      ),
    );
  }
}
