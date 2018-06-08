import 'package:flutter/material.dart';

import '../../classes/assessment.dart';
import '../../classes/goal_status.dart';
import '../../widgets/imko/imko_subject_widget.dart';
import '../subject.dart';

class IMKOGoalGroup {
  String groupName;
  List<IMKOGoal> goals;

  IMKOGoalGroup({this.groupName, this.goals});
}

class IMKOGoal {
  String index;
  String description;
  GoalStatus status;
  String workingTowardsComment;

  IMKOGoal();
  IMKOGoal.createNew({this.index, this.description, this.status, this.workingTowardsComment});

  factory IMKOGoal.fromApiJson(Map data) {
    IMKOGoal goal = new IMKOGoal();
    goal.index = data['Name'];
    goal.description = data['Description'];
    if (data['Value'] == 'Достиг' || data['Value'] == 'Achieved' || data['Value'] == 'Жетті') {
      goal.status = GoalStatus.achieved;
    } else if (data['Value'] == 'Стремится' || data['Value'] == 'Working Towards' || data['Value'] == 'Тырысады') {
      goal.status = GoalStatus.working_towards;
      goal.workingTowardsComment = data['Comment'];
      if (goal.workingTowardsComment.length == 0) {
        goal.workingTowardsComment = 'Нет комментария';
      }
    } else {
      goal.status = GoalStatus.none;
    }
    return goal;
  }
}

class IMKOSubject implements Subject {
  int id;
  String name;

  Assessment formative, summative;

  int quarter;

  String grade;
  IMKOSubject();
  IMKOSubject.createNew({
    this.id,
    this.name,
    this.formative,
    this.summative,
    this.quarter,
    this.grade,
  });

  double getPoints() {
    return formative.getPercentage() * 18.0 + summative.getPercentage() * 42.0;
  }

  int getRoundedPoints() {
    return getPoints().round();
  }

  double getPercentage() {
    return getPoints() / 60.0;
  }

  IMKOSubject.fromJson(Map json)
      : id = json["id"],
        name = json["name"],
        formative = Assessment.fromJSON(json["formative"]),
        summative = Assessment.fromJSON(json["summative"]),
        quarter = json["quarter"],
        grade = json["grade"];

  factory IMKOSubject.fromApiJson(Map json, int quarter) {
    IMKOSubject subject = new IMKOSubject();
    subject.id = json["Id"];
    subject.name = json["Name"];
    subject.formative = new Assessment(current: json["ApproveCnt"], maximum: json['Cnt']);
    subject.summative = new Assessment(current: json["ApproveISA"].toInt(), maximum: json['MaxISA'].toInt());
    subject.quarter = quarter;
    subject.grade = json["Period"];
    return subject;
  }

  bool alreadyAnimated = false;
  bool destroy = false;
  @override
  Widget createWidget() {
    return new IMKOSubjectWidget(
      viewModel: new IMKOSubjectViewModel(
        subject: this,
      ),
      animate: !alreadyAnimated,
      destroy: destroy,
    );
  }
}
