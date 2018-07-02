import 'package:enis_new/api/jko/jko_data.dart';
import 'package:enis_new/classes/assessment.dart';
import 'package:enis_new/widgets/jko/jko_evaluation_widget.dart';
import 'package:flutter/material.dart';

class JKOTermCalculatorWidget extends StatefulWidget {
  final String routedData;
  JKOTermCalculatorWidget({this.routedData = ''});
  @override
  _JKOTermCalculatorWidgetState createState() => _JKOTermCalculatorWidgetState();
}

class _JKOTermCalculatorWidgetState extends State<JKOTermCalculatorWidget> {
  int numberAssessments;
  List<JKOAssessment> assessments = new List();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4.0, right: 4.0),
            child: RaisedButton(
              color: Colors.green,
              child: Text('Add assessment'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0),
                ),
              ),
              onPressed: (assessments.length < 3)
                  ? () {
                      setState(() {
                        assessments.add(new JKOAssessment(
                          description: 'Assessment #1',
                          topic: Assessment(current: 10, maximum: 20),
                          quarter: Assessment(current: 11, maximum: 20),
                        ));
                      });
                    }
                  : null,
            ),
          );
        }
        return Row(
          children: <Widget>[
            Expanded(
              child: JKOEvaluationWidget(
                data: assessments[index - 1],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            )
          ],
        );
      },
      itemCount: assessments.length + 1,
    );
  }
}
