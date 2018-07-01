import 'package:enis_new/classes/assessment.dart';
import 'package:flutter/material.dart';


class AssessmentCurrentMaximumWidget extends StatelessWidget {
  final Assessment assessment;
  final String description;

  AssessmentCurrentMaximumWidget({this.assessment, this.description});
  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          assessment.current.toString(),
          style: Theme.of(context).textTheme.body1.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 40.0,
              ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontSize: 12.0,
                  ),
            ),
            Text(
              '/${assessment.maximum}',
              style: Theme.of(context).textTheme.subhead.copyWith(
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
    decimalPercentage = decimalPercentage.padRight(3, '0');
    return decimalPercentage;
  }
}

class AsssessmentPercentWidget extends StatelessWidget {
  final AssessmentPercentViewModel viewModel;
  final double animationValue;

  AsssessmentPercentWidget({this.viewModel, this.animationValue});

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          viewModel.calculateDisplayablePercentageInt(animationValue),
          style: Theme.of(context).textTheme.body1.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 40.0,
              ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              viewModel.calculateDisplayablePercentageDecimal(animationValue),
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontSize: 12.0,
                  ),
            ),
            Text(
              viewModel.description,
              style: Theme.of(context).textTheme.subhead.copyWith(
                    fontSize: 18.0,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
