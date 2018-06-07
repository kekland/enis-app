import 'package:flutter/material.dart';

import '../../classes/diary.dart';
import '../../classes/grade.dart';
import '../assessment_number_widget.dart';
import '../../classes/assessment.dart';
import '../grade_widget.dart';
import 'imko_goal_widget.dart';

class IMKOSubjectViewModel {
  String subjectName;
  Assessment formative;
  Assessment summative;
  int quarter;

  double calculateGradePercentage() {
    double percentage;
    if (summative.maximum == 0) {
      percentage = formative.getPercentage() * 60.0;
    } else {
      percentage = formative.getPercentage() * 18.0 + summative.getPercentage() * 42.0;
    }
    percentage /= 60.0;
    return percentage;
  }

  String calculateGrade() {
    if (summative.current == 0) {
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

  IMKOSubjectViewModel({this.subjectName, this.formative, this.summative, this.quarter});
}

class IMKOSubjectWidget extends StatefulWidget {
  final IMKOSubjectViewModel viewModel;
  final bool tappable;
  final bool animate;

  IMKOSubjectWidget({
    this.viewModel,
    this.tappable = true,
    this.animate = true,
  });
  @override
  _IMKOSubjectWidgetState createState() => new _IMKOSubjectWidgetState();
}

class _IMKOSubjectWidgetState extends State<IMKOSubjectWidget> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();
    if (widget.animate) {
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
    Navigator.of(ctx).push(
      new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(
              title: Text(widget.viewModel.subjectName),
            ),
            body: new SingleChildScrollView(
              child: new Padding(
                padding: EdgeInsets.all(16.0),
                child: new Column(
                  children: [
                    new IMKOSubjectWidget(
                      viewModel: widget.viewModel,
                      tappable: false,
                      animate: false,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
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
              widget.viewModel.subjectName,
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
                    assessment: Assessment.lerp(widget.viewModel.formative, animation.value),
                    description: 'FA',
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: new AssessmentCurrentMaximumWidget(
                  new AssessmentCurrentMaximumViewModel(
                    assessment: Assessment.lerp(widget.viewModel.summative, animation.value),
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
        tag: 'imko.${widget.viewModel.quarter}.${widget.viewModel.subjectName}.heroWidget',
        child: new Opacity(
          opacity: animation.value,
          child: new Card(
            child: new InkWell(
              onTap: () => onCardTap(context),
              child: cardChild,
            ),
          ),
        ),
      );
    } else {
      return new Hero(
        tag: 'imko.${widget.viewModel.quarter}.${widget.viewModel.subjectName}.heroWidget',
        child: Opacity(
          opacity: animation.value,
          child: Card(
            child: cardChild,
          ),
        ),
      );
    }
  }
}
