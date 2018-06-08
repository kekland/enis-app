import 'package:flutter/material.dart';

abstract class Subject {
  String name;
  String grade;
  Widget createWidget();
}
