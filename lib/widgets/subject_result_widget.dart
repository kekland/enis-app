import 'package:flutter/material.dart';

import '../classes/assessment.dart';

class SubjectResultIMKOViewModel {
  List<Assessment> formatives;
  List<Assessment> summatives;

  double calculatePoints() {
    int formativeCurrentSum = 0;
    int formativeMaximumSum = 0;

    int summativeCurrentSum = 0;
    int summativeMaximumSum = 0;

    for (Assessment formative in formatives) {
      formativeCurrentSum += formative.current;
      formativeMaximumSum += formative.maximum;
    }

    for (Assessment summative in summatives) {
      summativeCurrentSum += summative.current;
      summativeMaximumSum += summative.maximum;
    }

    return (formativeCurrentSum.toDouble() / formativeMaximumSum.toDouble()) * 18.0 + (summativeCurrentSum.toDouble() / summativeMaximumSum.toDouble()) * 42.0;
  }
}

class SubjectResultJKOViewModel {}

class SubjectResultWidget extends StatefulWidget {
  @override
  _SubjectResultWidgetState createState() => _SubjectResultWidgetState();
}

class _SubjectResultWidgetState extends State<SubjectResultWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
