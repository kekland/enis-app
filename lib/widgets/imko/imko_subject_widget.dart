import 'dart:async';

import 'package:flutter/material.dart';

import '../../api/imko/imko_api.dart';
import '../../api/imko/imko_data.dart';
import '../../classes/diary.dart';
import '../../classes/grade.dart';
import '../../global.dart';
import '../assessment_number_widget.dart';
import '../../classes/assessment.dart';
import '../grade_widget.dart';
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

class IMKOSubjectWidget extends StatefulWidget {
  final IMKOSubjectViewModel viewModel;
  final bool tappable;
  final bool animate;
  final bool destroy;

  IMKOSubjectWidget({
    this.viewModel,
    this.tappable = true,
    this.animate = true,
    this.destroy = false,
  });
  @override
  _IMKOSubjectWidgetState createState() => new _IMKOSubjectWidgetState();
}

class _IMKOSubjectWidgetState extends State<IMKOSubjectWidget> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();
    if ((widget.animate || widget.destroy) && Global.animate) {
      controller = new AnimationController(duration: Duration(milliseconds: 1500), vsync: this);
      final CurvedAnimation curve = new CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
      animation = new Tween(begin: 0.0, end: 1.0).animate(curve)
        ..addListener(() {
          setState(() {});
        });

      controller.forward();
    } else {
      animation = new AlwaysStoppedAnimation(1.0);
    }
  }

  @override
  void dispose() {
    if (controller != null) controller.dispose();
    super.dispose();
  }

  onCardTap(BuildContext ctx) {
    Navigator.of(ctx).push(new MaterialPageRoute(builder: (BuildContext ctx) {
      return IMKOSubjectDetailPage(viewModel: widget.viewModel);
    }));
  }

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
              widget.viewModel.subject.name,
              style: Theme.of(context).textTheme.body1.copyWith(
                    fontSize: 18.0,
                  ),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: new AssessmentCurrentMaximumWidget(
                  new AssessmentCurrentMaximumViewModel(
                    assessment: Assessment.lerp(widget.viewModel.subject.formative, animation.value),
                    description: 'FA',
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: new AssessmentCurrentMaximumWidget(
                  new AssessmentCurrentMaximumViewModel(
                    assessment: Assessment.lerp(widget.viewModel.subject.summative, animation.value),
                    description: 'SA',
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: new GradeWidget(
                  viewModel: new GradeWidgetViewModel(
                    grade: widget.viewModel.calculateGrade(),
                    gradeColor: widget.viewModel.calculateGradeColor(),
                    percentage: widget.viewModel.calculateGradePercentage(),
                  ),
                  animationValue: animation.value,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (widget.tappable) {
      return new Hero(
        tag: 'imko.${widget.viewModel.subject.quarter}.${widget.viewModel.subject.name}.heroWidget',
        child: new Opacity(
          opacity: (widget.destroy) ? 1.0 - animation.value : animation.value,
          child: new Card(
            margin: EdgeInsets.zero,
            child: new InkWell(
              onTap: () => onCardTap(context),
              child: cardChild,
            ),
          ),
        ),
      );
    } else {
      return new Hero(
        tag: 'imko.${widget.viewModel.subject.quarter}.${widget.viewModel.subject.name}.heroWidget',
        child: Opacity(
          opacity: (widget.destroy) ? 1.0 - animation.value : animation.value,
          child: Card(
            margin: EdgeInsets.zero,
            child: cardChild,
          ),
        ),
      );
    }
  }
}
