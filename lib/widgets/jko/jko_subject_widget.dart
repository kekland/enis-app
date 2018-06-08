import 'package:flutter/material.dart';

import '../../api/jko/jko_data.dart';
import '../../classes/diary.dart';
import '../../classes/grade.dart';
import '../../global.dart';
import '../assessment_number_widget.dart';
import '../grade_widget.dart';
import 'jko_evaluation_widget.dart';
import 'jko_subject_detail_widget.dart';

class JKOSubjectViewModel {
  JKOSubject subject;

  double getPercentageToDisplay() {
    return subject.points * 100.0;
  }

  String calculateGrade() {
    if (subject.points == 0.0) {
      return '-';
    } else {
      return Grade.toNumericalGrade(Grade.calculateGrade(subject.points, Diary.jko));
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

  JKOSubjectViewModel({this.subject});
}

class JKOSubjectWidget extends StatefulWidget {
  final JKOSubjectViewModel viewModel;
  final bool tappable;
  final bool animate;
  final bool destroy;

  JKOSubjectWidget({
    this.viewModel,
    this.tappable = true,
    this.animate = true,
    this.destroy = false,
  });

  @override
  _JKOSubjectWidgetState createState() => new _JKOSubjectWidgetState();
}

class _JKOSubjectWidgetState extends State<JKOSubjectWidget> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();
    if (widget.animate && Global.animate) {
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
          return new JKOSubjectDetailPage(viewModel: widget.viewModel,);
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
              widget.viewModel.subject.name,
              style: Theme.of(context).textTheme.body1.copyWith(
                    fontSize: 18.0,
                  ),
            ),
          ),
          new Row(
            children: <Widget>[
              new AsssesmentPercentWidget(
                viewModel: new AssessmentPercentViewModel(
                  percentage: widget.viewModel.getPercentageToDisplay(),
                  description: '%',
                ),
                animationValue: animation.value,
              ),
              new Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: new GradeWidget(
                  viewModel: new GradeWidgetViewModel(
                    grade: widget.viewModel.calculateGrade(),
                    gradeColor: widget.viewModel.calculateGradeColor(),
                    percentage: 0.85,
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
        tag: 'jko.${widget.viewModel.subject.quarter}.${widget.viewModel.subject.name}.heroWidget',
        child: new Opacity(
          opacity: (widget.destroy) ? 1.0 - animation.value : animation.value,
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
        tag: 'jko.${widget.viewModel.subject.quarter}.${widget.viewModel.subject.name}.heroWidget',
        child: Opacity(
          opacity: (widget.destroy) ? 1.0 - animation.value : animation.value,
          child: Card(
            child: cardChild,
          ),
        ),
      );
    }
  }
}
