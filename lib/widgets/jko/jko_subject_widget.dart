import 'package:enis_new/api/jko/jko_data.dart';
import 'package:enis_new/classes/diary.dart';
import 'package:enis_new/classes/grade.dart';
import 'package:enis_new/widgets/assessment_number_widget.dart';
import 'package:enis_new/widgets/grade_widget.dart';
import 'package:enis_new/widgets/jko/jko_subject_detail_widget.dart';
import 'package:flutter/material.dart';

class JKOSubjectWidget extends StatelessWidget {
  final JKOSubject subject;
  final bool tappable;
  final double animationValue;
  JKOSubjectWidget({
    this.subject,
    this.tappable = true,
    this.animationValue = 1.0,
  });

  onCardTap(BuildContext ctx) {
    Navigator.of(ctx).push(
      new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new JKOSubjectDetailPage(
            subject: subject,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget cardChild = new Container(
      padding: EdgeInsets.all(16.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          new Expanded(
            child: Text(
              subject.name,
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 20.0, fontFamily: 'Futura', fontWeight: FontWeight.w400),
            ),
          ),
          new Row(
            children: <Widget>[
              new AsssessmentPercentWidget(
                viewModel: new AssessmentPercentViewModel(
                  percentage: subject.calculateGradePercentage() * 100.0,
                  description: '%',
                ),
                animationValue: animationValue,
              ),
              new Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: new GradeWidget(
                  viewModel: new GradeWidgetViewModel(
                    grade: subject.calculateGrade(),
                    gradeColor: subject.calculateGradeColor(),
                    percentage: 0.85,
                  ),
                  animationValue: animationValue,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (tappable) {
      return new Hero(
        tag: 'jko.${subject.quarter}.${subject.name}.heroWidget',
        child: new Opacity(
          opacity: animationValue,
          child: new Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: new InkWell(
              onTap: () => onCardTap(context),
              child: cardChild,
            ),
          ),
        ),
      );
    } else {
      return new Hero(
        tag: 'jko.${subject.quarter}.${subject.name}.heroWidget',
        child: Opacity(
          opacity: animationValue,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: cardChild,
          ),
        ),
      );
    }
  }
}
