import 'dart:convert';
import 'package:enis_new/widgets/bottom_sheet_fix.dart';
import 'package:enis_new/api/imko/imko_data.dart';
import 'package:enis_new/classes/assessment.dart';
import 'package:enis_new/widgets/assessment_number_widget.dart';
import 'package:enis_new/widgets/calculator/imko_term_calculator_widget.dart';
import 'package:enis_new/widgets/grade_widget.dart';
import 'package:enis_new/widgets/imko/imko_subject_detail_widget.dart';
import 'package:flutter/material.dart';

class IMKOSubjectWidget extends StatelessWidget {
  final IMKOSubject subject;
  final bool tappable;
  final Animation<double> animation;

  IMKOSubjectWidget({
    this.subject,
    this.tappable = true,
    this.animation = const AlwaysStoppedAnimation(1.0),
  });

  onCardTap(BuildContext ctx) {
    Navigator.of(ctx).push(new MaterialPageRoute(builder: (BuildContext ctx) {
      return IMKOSubjectDetailPage(subject: subject);
    }));
  }

  TapDownDetails details;
  @override
  Widget build(BuildContext context) {
    Widget cardChild = new Container(
      padding: EdgeInsets.all(16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              subject.name,
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 20.0, fontFamily: 'Futura', fontWeight: FontWeight.w400),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: new AssessmentCurrentMaximumWidget(
                  assessment: Assessment.lerp(subject.formative, animation.value),
                  description: 'FA',
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: new AssessmentCurrentMaximumWidget(
                  assessment: Assessment.lerp(subject.summative, animation.value),
                  description: 'SA',
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: new GradeWidget(
                  viewModel: new GradeWidgetViewModel(
                    grade: subject.calculateGrade(),
                    gradeColor: subject.calculateGradeColor(),
                    percentage: subject.calculateGradePercentage(),
                  ),
                  animationValue: animation.value,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (tappable) {
      return new Hero(
        tag: 'imko.${subject.quarter}.${subject.name}.heroWidget',
        child: new Opacity(
          opacity: animation.value,
          child: new Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            margin: EdgeInsets.zero,
            child: new InkWell(
              onTapDown: ((TapDownDetails details) {
                this.details = details;
              }),
              onLongPress: () =>
                  /*Global.router.navigateTo(
                    context,
                    '/calculator?type=1&data=${json.encode(subject.toJSON())}',
                    transition: TransitionType.custom,
                    transitionBuilder: ((BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                      return new PageRevealWidget(
                        revealPercent: animation.value,
                        child: child,
                        clickPosition: details.globalPosition,
                      );
                    }),
                  ),*/
                  showModalBottomSheetFixed(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: new IMKOSubjectWidget(
                                subject: subject,
                                tappable: false,
                              ),
                            ),
                            IMKOTermCalculatorWidget(
                              routedData: json.encode(subject.toJSON()),
                            ),
                          ],
                        );
                      },
                      dismissOnTap: false,
                      resizeToAvoidBottomPadding: true),
              onTap: () => onCardTap(context),
              child: cardChild,
            ),
          ),
        ),
      );
    } else {
      return new Hero(
        tag: 'imko.${subject.quarter}.${subject.name}.heroWidget',
        child: Opacity(
          opacity: animation.value,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            margin: EdgeInsets.zero,
            child: cardChild,
          ),
        ),
      );
    }
  }
}
