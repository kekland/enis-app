import 'package:flutter/material.dart';

abstract class Subject {
  String name;
  String grade;
  Widget createWidget(Animation<double> animation);

  double calculateGradePercentage();
  String calculateGrade();
  String calculateGradeNumerical();
  Color calculateGradeColor();
}
