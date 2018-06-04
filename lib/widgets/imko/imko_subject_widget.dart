import 'package:flutter/material.dart';

import '../../classes/diary.dart';
import '../../classes/grade.dart';
import '../assessment_number_widget.dart';
import '../../classes/assessment.dart';
import '../grade_widget.dart';

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

class IMKOSubjectWidget extends StatelessWidget {
  final IMKOSubjectViewModel viewModel;
  final bool tappable;

  IMKOSubjectWidget({this.viewModel, this.tappable = true});

  onCardTap(BuildContext ctx) {
    Navigator.of(ctx).push(
      new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(
              title: Text(viewModel.subjectName),
            ),
            body: new Container(
                padding: const EdgeInsets.all(8.0), alignment: Alignment.topLeft, child: new IMKOSubjectWidget(viewModel: viewModel, tappable: false)),
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
                percentage: viewModel.calculateGradePercentage(),
              ),
            ),
          ),
          new Expanded(
            child: Text(
              viewModel.subjectName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
              ),
            ),
          ),
          new Row(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: new AssessmentCurrentMaximumWidget(
                  new AssessmentCurrentMaximumViewModel(
                    assessment: viewModel.formative,
                    description: 'FA',
                    isColored: false,
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: new AssessmentCurrentMaximumWidget(
                  new AssessmentCurrentMaximumViewModel(
                    assessment: viewModel.summative,
                    description: 'SA',
                    isColored: false,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (tappable) {
      return new Hero(
        tag: 'imko.${viewModel.quarter}.${viewModel.subjectName}.heroWidget',
        child: new Card(
          child: new InkWell(
            onTap: () => onCardTap(context),
            child: cardChild,
          ),
        ),
      );
    } else {
      return new Hero(
        tag: 'imko.${viewModel.quarter}.${viewModel.subjectName}.heroWidget',
        child: Card(
          child: cardChild,
        ),
      );
    }
  }
}
