import 'package:flutter/material.dart';

import '../../classes/diary.dart';
import '../../classes/grade.dart';
import '../assessment_number_widget.dart';
import '../grade_widget.dart';

class JKOSubjectViewModel {
  String subjectName;
  double percentage;
  int quarter;

  double getPercentageToDisplay() {
    return percentage * 100.0;
  }

  String calculateGrade() {
    if (percentage == 0.0) {
      return '-';
    } else {
      return Grade.toNumericalGrade(Grade.calculateGrade(percentage, Diary.jko));
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

  JKOSubjectViewModel({this.subjectName, this.percentage, this.quarter});
}

class JKOSubjectWidget extends StatefulWidget {
  final JKOSubjectViewModel viewModel;
  final bool tappable;
  final bool animate;

  JKOSubjectWidget({
    this.viewModel,
    this.tappable = true,
    this.animate = true,
  });

  @override
  _JKOSubjectWidgetState createState() => new _JKOSubjectWidgetState();
}

class _JKOSubjectWidgetState extends State<JKOSubjectWidget> with SingleTickerProviderStateMixin {
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
            body: new Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.topLeft,
              child: new JKOSubjectWidget(
                viewModel: widget.viewModel,
                tappable: false,
                animate: false,
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
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          new Expanded(
            child: Text(
              'English',
              style: TextStyle(
                color: Colors.black,
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
        tag: 'jko.${widget.viewModel.quarter}.${widget.viewModel.subjectName}.heroWidget',
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
        tag: 'jko.${widget.viewModel.quarter}.${widget.viewModel.subjectName}.heroWidget',
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
