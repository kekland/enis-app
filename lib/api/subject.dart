import 'package:flutter/material.dart';

abstract class Subject {
  String name;
  String grade;

  double calculateGradePercentage();
  String calculateGrade();
  String calculateGradeNumerical();
  Color calculateGradeColor();
}
