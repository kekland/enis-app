import 'package:flutter/material.dart';

class GradeWidgetViewModel {
  String grade;
  Color gradeColor;
  double percentage;

  String getDisplayPercentage() {
    return (percentage * 100.0).toStringAsFixed(3);
  }

  GradeWidgetViewModel({this.grade, this.gradeColor, this.percentage = 0.0});
}

class GradeWidget extends StatelessWidget {
  final GradeWidgetViewModel viewModel;
  final double animationValue;

  GradeWidget({this.viewModel, this.animationValue = 1.0});
  @override
  Widget build(BuildContext context) {
    if (viewModel.percentage == 0.0) {
      return new Opacity(
        opacity: animationValue,
        child: new Stack(
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
        ),
      );
    } else {
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Stack(
            alignment: AlignmentDirectional.center,
            children: [
              new CircularProgressIndicator(
                value: viewModel.percentage * animationValue,
                valueColor: AlwaysStoppedAnimation(viewModel.gradeColor),
              ),
              Text(
                viewModel.grade,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color.lerp(Colors.red.shade400, viewModel.gradeColor, animationValue).withOpacity(animationValue),
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}
