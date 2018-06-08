import 'package:flutter/material.dart';

abstract class Subject {
  String name;
  String grade;

  bool alreadyAnimated = false;
  bool destroy = false;
  Widget createWidget();
}
