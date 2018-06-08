import 'package:flutter/widgets.dart';

import '../subject.dart';

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

  bool alreadyAnimated = false;
  bool destroy = false;
  @override
  Widget createWidget() {
    return null;
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
    result.grade = data['Mark'];
    result.name = data['Name'];
    result.points = data['Score'];
    result.evaluations = new List();

    List evals = data['Evalutions'];
    for (Map evaluation in evals) {
      result.evaluations.add(new JKOSubjectEvaluation.fromApiJson(evaluation));
    }

    return result;
  }
}