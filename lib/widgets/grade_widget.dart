import 'package:flutter/material.dart';

import 'animated_circular_progress.dart';

class GradeWidgetViewModel {
  String grade;
  Color gradeColor;
  double percentage;

  GradeWidgetViewModel({this.grade, this.gradeColor, this.percentage = 0.0});
}

class GradeWidget extends StatelessWidget {
  final GradeWidgetViewModel viewModel;

  GradeWidget({this.viewModel});
  @override
  Widget build(BuildContext context) {
    if (viewModel.percentage == 0.0) {
      return new Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            width: 36.0,
            height: 36.0,
            decoration: BoxDecoration(
              color: viewModel.gradeColor,
              shape: BoxShape.circle,
            ),
          ),
          CircularProgressIndicator(
            value: 1.0,
            valueColor: AlwaysStoppedAnimation(viewModel.gradeColor),
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
    } else {
      return new Stack(
        alignment: AlignmentDirectional.center,
        children: [
          new AnimatedCircularProgressWidget(
            value: viewModel.percentage,
            color: viewModel.gradeColor,
          ),
          Text(
            viewModel.grade,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: viewModel.gradeColor,
              fontSize: 24.0,
            ),
          ),
        ],
      );
    }
  }
}
