import 'dart:convert';

import 'package:enis_new/api/imko/imko_data.dart';
import 'package:enis_new/classes/assessment.dart';
import 'package:enis_new/classes/diary.dart';
import 'package:enis_new/classes/grade.dart';
import 'package:enis_new/widgets/assessment_number_widget.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  final int routedIndex;
  final String routedData;

  CalculatorPage({this.routedIndex = 0, this.routedData = ''});
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

List<String> tabs = ['IMKO Term', 'JKO Term', 'IMKO Year', 'JKO Year'];

class _CalculatorPageState extends State<CalculatorPage> {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 4,
      initialIndex: widget.routedIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Calculator'),
          bottom: TabBar(
            tabs: tabs.map((String tab) {
              return Tab(text: tab);
            }).toList(),
          ),
        ),
        body: TabBarView(children: [
          IMKOTermCalculatorPage(routedData: (widget.routedIndex == 0) ? widget.routedData : ''),
          Container(child: Center(child: Text('In development'))),
          Container(child: Center(child: Text('In development'))),
          Container(child: Center(child: Text('In development'))),
        ]),
      ),
    );
  }
}

class TextFieldRoundedEdges extends StatelessWidget {
  final String label;
  TextFieldRoundedEdges({this.label});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(100.0),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 12.0),
          isDense: true,
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class IMKOTermCalculatorPage extends StatefulWidget {
  final String routedData;
  IMKOTermCalculatorPage({this.routedData = ''});
  @override
  IMKOTermCalculatorPageState createState() {
    return new IMKOTermCalculatorPageState();
  }
}

class IMKOTermCalculatorPageState extends State<IMKOTermCalculatorPage> {
  Assessment formative = new Assessment(current: 10, maximum: 10);
  Assessment summative = new Assessment(current: 40, maximum: 40);

  @override
  initState() {
    super.initState();
    print(widget.routedData);
    if (widget.routedData.length != 0) {
      IMKOSubject subject = IMKOSubject.fromJson(json.decode(widget.routedData));
      formative = subject.formative;
      summative = subject.summative;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: new SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: TextFieldRoundedEdges(label: 'Current FA'),
                ),
                Flexible(
                  flex: 1,
                  child: TextFieldRoundedEdges(label: 'Maximum FA'),
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: TextFieldRoundedEdges(label: 'Current SA'),
                ),
                Flexible(
                  flex: 1,
                  child: TextFieldRoundedEdges(label: 'Maximum SA'),
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                    child: Center(
                      child: AssessmentCurrentMaximumWidget(AssessmentCurrentMaximumViewModel(
                        assessment: Assessment(current: 59, maximum: 60),
                        description: 'Total',
                      )),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'B',
                              style: Theme.of(context).textTheme.body1.copyWith(
                                    fontSize: 24.0,
                                    color: Colors.white,
                                  ),
                            ),
                            Text(
                              '(4)',
                              style: Theme.of(context).textTheme.body1.copyWith(
                                    fontSize: 24.0,
                                    color: Colors.white70,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
