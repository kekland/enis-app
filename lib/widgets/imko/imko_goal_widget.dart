import 'package:flutter/material.dart';

import '../../api/imko/imko_data.dart';
import '../../classes/goal_status.dart';


class IMKOGoalWidget extends StatelessWidget {
  final IMKOGoal goal;

  IMKOGoalWidget({this.goal});
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  goal.index,
                  style: Theme.of(context).textTheme.body1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Chip(
                  label: Text(
                    (goal.status == GoalStatus.achieved)? 'Achieved' : 'Working Towards',
                    style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),
                  ),
                  backgroundColor: (goal.status == GoalStatus.achieved)? Colors.green : Colors.amber,
                )
              ],
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                goal.description
              ),
            ),
          ],
        ),
      ),
    );
  }
}
