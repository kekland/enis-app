import 'package:enis_new/api/subject.dart';
import 'package:enis_new/classes/assessment.dart';
import 'package:enis_new/classes/diary.dart';
import 'package:enis_new/classes/grade.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class JKOAssessment {
  String description;
  Assessment topic;
  Assessment quarter;

  JKOAssessment({this.description, this.topic, this.quarter});

  factory JKOAssessment.fromApiJson(Map jsonTopic, Map jsonQuarter) {
    return JKOAssessment(
      description: jsonTopic['Name'],
      topic: Assessment(
        current: jsonTopic['Score'].round(),
        maximum: jsonTopic['MaxScore'],
      ),
      quarter: Assessment(
        current: jsonQuarter['Score'].round(),
        maximum: jsonQuarter['MaxScore'],
      ),
    );
  }
}

class JKOSubjectEvaluation {
  String evaluationName;
  String evaluationID;

  JKOSubjectEvaluation();
  JKOSubjectEvaluation.createNew({
    this.evaluationID,
    this.evaluationName,
  });
  factory JKOSubjectEvaluation.fromApiJson(Map data) {
    return new JKOSubjectEvaluation.createNew(evaluationID: data['Id'], evaluationName: data['ShortName']);
  }
}

class JKOSubject implements Subject {
  String id;
  String diaryId;

  String name;

  int quarter;
  String grade;
  double points;

  List<JKOSubjectEvaluation> evaluations;

  @override
  Widget createWidget(Animation<double> animation) {
    /*return JKOSubjectWidget(
      animation: animation,
      viewModel: JKOSubjectViewModel(subject: this),
    );*/
  }

  JKOSubject();
  JKOSubject.createNew({
    this.id,
    this.diaryId,
    this.name,
    this.quarter,
    this.grade,
    this.points,
    this.evaluations,
  });

  factory JKOSubject.fromApiJson(Map data) {
    JKOSubject result = new JKOSubject();

    result.id = data['Id'];
    result.diaryId = data['JournalId'];
    result.grade = data['Mark'].toString();
    result.name = data['Name'];
    result.points = data['Score'] / 100.0;
    result.evaluations = new List();

    List evals = data['Evalutions'];
    for (Map evaluation in evals) {
      result.evaluations.add(new JKOSubjectEvaluation.fromApiJson(evaluation));
    }

    return result;
  }

  @override
  double calculateGradePercentage() {
    return points;
  }

  @override
  String calculateGrade() {
    if (points == 0) {
      return '-';
    } else {
      double percentage = calculateGradePercentage();
      return Grade.calculateGrade(percentage, Diary.jko);
    }
  }

  @override
  String calculateGradeNumerical() {
    if (points == 0) {
      return '-';
    } else {
      double percentage = calculateGradePercentage();
      return Grade.toNumericalGrade(Grade.calculateGrade(percentage, Diary.jko));
    }
  }

  @override
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
}
