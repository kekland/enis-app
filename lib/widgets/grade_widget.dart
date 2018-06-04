import 'package:flutter/material.dart';

class GradeWidgetViewModel {
  String grade;
  Color gradeColor;
  double percentage;

  GradeWidgetViewModel({this.grade, this.gradeColor, this.percentage = 0.0});
}

class GradeWidget extends StatelessWidget {
  GradeWidgetViewModel viewModel;

  GradeWidget({this.viewModel});
  @override
  Widget build(BuildContext context) {
    if (viewModel.percentage == 0.0) {
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
    } else {
      return new Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CircularProgressIndicator(
            value: viewModel.percentage,
          ),
          Text(
            viewModel.grade,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 24.0,
            ),
          ),
        ],
      );
    }
  }
}
