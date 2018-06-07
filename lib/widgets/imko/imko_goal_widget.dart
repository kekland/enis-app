import 'package:flutter/material.dart';

import '../../classes/goal_status.dart';

class IMKOGoalViewModel {
  String goalNumber;
  String goalDescription;
  GoalStatus goalStatus;

  String workingTowardsComment;

  IMKOGoalViewModel({this.goalNumber, this.goalDescription, this.goalStatus, this.workingTowardsComment = ""});
}

class IMKOGoalWidget extends StatelessWidget {
  final IMKOGoalViewModel viewModel;

  IMKOGoalWidget({this.viewModel});
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '1.0.1',
                  style: Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text('Achieved',
                    style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),),
                  backgroundColor: Colors.green,
                )
              ],
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin id feugiat orci. Sed vestibulum at nunc sed tincidunt. Praesent viverra velit quis dapibus eleifend. Sed sem lorem, convallis non pharetra ac, scelerisque vel sem. Aenean sed augue odio. Vivamus mollis nulla in fermentum ullamcorper.',
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white70),
                  ),
                  Text(
                    'Vestibulum eget pellentesque dui, at fringilla mauris.',
                    style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
