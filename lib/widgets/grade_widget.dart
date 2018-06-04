import 'package:flutter/material.dart';

class GradeWidgetViewModel {
  String grade;
  Color gradeColor;

  GradeWidgetViewModel({this.grade, this.gradeColor});
}

class GradeWidget extends StatelessWidget {
  GradeWidgetViewModel viewModel;

  GradeWidget({this.viewModel});
  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: viewModel.gradeColor,
      ),
      child: new Text(
        viewModel.grade,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: 24.0,
        ),
      ),
    );
  }
}
