import 'dart:convert';

import 'package:enis_new/api/imko/imko_data.dart';
import 'package:enis_new/classes/assessment.dart';
import 'package:enis_new/classes/diary.dart';
import 'package:enis_new/classes/grade.dart';
import 'package:enis_new/global.dart';
import 'package:enis_new/widgets/assessment_number_widget.dart';
import 'package:enis_new/widgets/grade_widget.dart';
import 'package:enis_new/widgets/imko/imko_subject_detail_widget.dart';
import 'package:enis_new/widgets/page_reveal_widget.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class IMKOSubjectViewModel {
  IMKOSubject subject;

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
                    grade: viewModel.subject.calculateGrade(),
                    gradeColor: viewModel.subject.calculateGradeColor(),
                    percentage: viewModel.subject.calculateGradePercentage(),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            margin: EdgeInsets.zero,
            child: cardChild,
          ),
        ),
      );
    }
  }
}
