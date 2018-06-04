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

class JKOSubjectWidget extends StatelessWidget {
  final JKOSubjectViewModel viewModel;
  final bool tappable;

  JKOSubjectWidget({this.viewModel, this.tappable = true});

  onCardTap(BuildContext ctx) {
    Navigator.of(ctx).push(
      new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(
              title: Text(viewModel.subjectName),
            ),
            body: new Container(
                padding: const EdgeInsets.all(8.0), alignment: Alignment.topLeft, child: new JKOSubjectWidget(viewModel: viewModel, tappable: false)),
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
          new Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: new GradeWidget(
              viewModel: new GradeWidgetViewModel(
                grade: viewModel.calculateGrade(),
                gradeColor: viewModel.calculateGradeColor(),
                percentage: 0.85,
              ),
            ),
          ),
          new Expanded(
            child: Text(
              'English',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
              ),
            ),
          ),
          new Row(
            children: <Widget>[
              new AsssesmentPercentWidget(
                new AssessmentPercentViewModel(
                  percentage: viewModel.getPercentageToDisplay(),
                  description: '%',
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (tappable) {
      return new Hero(
        tag: 'jko.${viewModel.quarter}.${viewModel.subjectName}.heroWidget',
        child: new Card(
          child: new InkWell(
            onTap: () => onCardTap(context),
            child: cardChild,
          ),
        ),
      );
    } else {
      return new Hero(
        tag: 'jko.${viewModel.quarter}.${viewModel.subjectName}.heroWidget',
        child: Card(
          child: cardChild,
        ),
      );
    }
  }
}
