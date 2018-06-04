import 'package:flutter/material.dart';

class AssessmentPercentViewModel {
  int assessmentCurrent;
  int assessmentMaximum;
  String description;
  bool isColored;

  AssessmentPercentViewModel({this.assessmentCurrent, this.assessmentMaximum, this.description, this.isColored});
}

class AssessmentPercentWidget extends StatelessWidget {
  final AssessmentPercentViewModel viewModel;

  AssessmentPercentWidget(this.viewModel);
  @override
  Widget build(BuildContext context) {
    Color mainTextColor = Colors.black87;
    if (viewModel.isColored) {
      double percentage = viewModel.assessmentCurrent.toDouble() / viewModel.assessmentMaximum.toDouble();
      if (percentage > 0.7) {
        mainTextColor = Colors.green;
      } else if (percentage > 0.5) {
        mainTextColor = Colors.amber;
      } else if (percentage > 0.3) {
        mainTextColor = Colors.red;
      } else {
        mainTextColor = Colors.black87;
      }
    }
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          viewModel.assessmentCurrent.toString(),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: mainTextColor,
            fontSize: 40.0,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              viewModel.description,
              style: TextStyle(
                color: Colors.black45,
                fontSize: 12.0,
              ),
            ),
            Text(
              viewModel.assessmentMaximum.toString(),
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
