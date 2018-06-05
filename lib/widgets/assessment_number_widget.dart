import 'package:flutter/material.dart';

import '../classes/assessment.dart';

class AssessmentCurrentMaximumViewModel {
  Assessment assessment;
  String description;
  bool isColored;

  AssessmentCurrentMaximumViewModel({this.assessment, this.description, this.isColored});
}

class AssessmentCurrentMaximumWidget extends StatelessWidget {
  final AssessmentCurrentMaximumViewModel viewModel;

  AssessmentCurrentMaximumWidget(this.viewModel);
  @override
  Widget build(BuildContext context) {
    Color mainTextColor = Colors.black87;
    if (viewModel.isColored) {
      double percentage = viewModel.assessment.current.toDouble() / viewModel.assessment.maximum.toDouble();
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
          viewModel.assessment.current.toString(),
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
                color: Colors.black26,
                fontSize: 12.0,
              ),
            ),
            Text(
              '/${viewModel.assessment.maximum}',
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

class AssessmentPercentViewModel {
  double percentage;
  String description;

  AssessmentPercentViewModel({this.percentage, this.description});

  String calculateDisplayablePercentageInt([double animationValue = 1.0]) {
    double percentageToUse = percentage * animationValue;
    return percentageToUse.floor().toString();
  }

  String calculateDisplayablePercentageDecimal([double animationValue = 1.0]) {
    double percentageToUse = percentage * animationValue;
    String decimalPercentage = (percentageToUse - percentageToUse.floor()).toString().substring(1);
    if (decimalPercentage.length > 3) {
      decimalPercentage = decimalPercentage.substring(0, 3);
    }
    return decimalPercentage;
  }
}

class AsssesmentPercentWidget extends StatelessWidget {
  final AssessmentPercentViewModel viewModel;
  final double animationValue;

  AsssesmentPercentWidget({this.viewModel, this.animationValue});

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          viewModel.calculateDisplayablePercentageInt(animationValue),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontSize: 40.0,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              viewModel.calculateDisplayablePercentageDecimal(animationValue),
              style: TextStyle(
                color: Colors.black26,
                fontSize: 12.0,
              ),
            ),
            Text(
              viewModel.description,
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
