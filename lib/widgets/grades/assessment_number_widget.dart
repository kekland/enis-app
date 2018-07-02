import 'package:enis_new/classes/assessment.dart';
import 'package:flutter/material.dart';

class AssessmentCurrentMaximumWidget extends StatelessWidget {
  final Assessment assessment;
  final double animationValue;
  final String description;

  AssessmentCurrentMaximumWidget({this.assessment, this.animationValue = 1.0, this.description});
  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Assessment.lerp(assessment, animationValue).current.toString(),
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
              '/${Assessment.lerp(assessment, animationValue).maximum}',
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

class AsssessmentPercentWidget extends StatelessWidget {
  final double percentage;
  final String description;
  final double animationValue;

  AsssessmentPercentWidget({this.percentage, this.animationValue = 1.0, this.description = '%'});

  String calculateDisplayablePercentageInt() {
    double percentageToUse = percentage * animationValue;
    return percentageToUse.floor().toString();
  }

  String calculateDisplayablePercentageDecimal() {
    double percentageToUse = percentage * animationValue;
    String decimalPercentage = (percentageToUse - percentageToUse.floor()).toString().substring(1);
    if (decimalPercentage.length > 3) {
      decimalPercentage = decimalPercentage.substring(0, 3);
    }
    decimalPercentage = decimalPercentage.padRight(3, '0');
    return decimalPercentage;
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          calculateDisplayablePercentageInt(),
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
              calculateDisplayablePercentageDecimal(),
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontSize: 12.0,
                  ),
            ),
            Text(
              description,
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
