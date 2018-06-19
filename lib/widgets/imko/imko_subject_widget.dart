import 'dart:async';
import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../../api/imko/imko_api.dart';
import '../../api/imko/imko_data.dart';
import '../../classes/diary.dart';
import '../../classes/grade.dart';
import '../../global.dart';
import '../assessment_number_widget.dart';
import '../../classes/assessment.dart';
import '../grade_widget.dart';
import '../page_reveal_widget.dart';
import 'imko_subject_detail_widget.dart';

class IMKOSubjectViewModel {
  IMKOSubject subject;

  double calculateGradePercentage() {
    double percentage;
    if (subject.summative.maximum == 0) {
      percentage = subject.formative.getPercentage() * 60.0;
    } else {
      percentage = subject.formative.getPercentage() * 18.0 + subject.summative.getPercentage() * 42.0;
    }
    percentage.roundToDouble();
    percentage /= 60.0;
    return percentage;
  }

  String calculateGrade() {
    if (subject.summative.current == 0 && subject.summative.maximum != 0) {
      return '-';
    } else {
      double percentage = calculateGradePercentage();
      return Grade.toNumericalGrade(Grade.calculateGrade(percentage, Diary.imko));
    }
  }

  Color calculateGradeColor() {
    String numericGrade = calculateGrade();
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
        return Colors.black12;
    }
  }

  IMKOSubjectViewModel({this.subject});
}

class IMKOSubjectWidget extends StatelessWidget {
  final IMKOSubjectViewModel viewModel;
  final bool tappable;
  final Animation<double> animation;

  IMKOSubjectWidget({
    this.viewModel,
    this.tappable = true,
    this.animation = const AlwaysStoppedAnimation(1.0),
  });

  onCardTap(BuildContext ctx) {
    Navigator.of(ctx).push(new MaterialPageRoute(builder: (BuildContext ctx) {
      return IMKOSubjectDetailPage(viewModel: viewModel);
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
              viewModel.subject.name,
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 20.0, fontFamily: 'Futura', fontWeight: FontWeight.w400),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: new AssessmentCurrentMaximumWidget(
                  new AssessmentCurrentMaximumViewModel(
                    assessment: Assessment.lerp(viewModel.subject.formative, animation.value),
                    description: 'FA',
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: new AssessmentCurrentMaximumWidget(
                  new AssessmentCurrentMaximumViewModel(
                    assessment: Assessment.lerp(viewModel.subject.summative, animation.value),
                    description: 'SA',
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: new GradeWidget(
                  viewModel: new GradeWidgetViewModel(
                    grade: viewModel.calculateGrade(),
                    gradeColor: viewModel.calculateGradeColor(),
                    percentage: viewModel.calculateGradePercentage(),
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
        tag: 'imko.${viewModel.subject.quarter}.${viewModel.subject.name}.heroWidget',
        child: new Opacity(
          opacity: animation.value,
          child: new Card(
            margin: EdgeInsets.zero,
            child: new InkWell(
              onTapDown: ((TapDownDetails details) {
                this.details = details;
              }),
              onLongPress: () => Global.router.navigateTo(
                    context,
                    '/calculator?type=1&data=${json.encode(viewModel.subject.toJSON())}',
                    transition: TransitionType.custom,
                    transitionBuilder: ((BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                      return new PageRevealWidget(
                        revealPercent: animation.value,
                        child: child,
                        clickPosition: details.globalPosition,
                      );
                    }),
                  ),
              onTap: () => onCardTap(context),
              child: cardChild,
            ),
          ),
        ),
      );
    } else {
      return new Hero(
        tag: 'imko.${viewModel.subject.quarter}.${viewModel.subject.name}.heroWidget',
        child: Opacity(
          opacity: animation.value,
          child: Card(
            margin: EdgeInsets.zero,
            child: cardChild,
          ),
        ),
      );
    }
  }
}
