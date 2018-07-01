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
  final TextEditingController controller;
  TextFieldRoundedEdges({
    this.label,
    this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(100.0),
        ),
      ),
      child: TextField(
        controller: controller,
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
  bool error = false;

  TextEditingController currentFAController, maximumFAController, currentSAController, maximumSAController;

  dataChanged() {
    Assessment formativeTemp = new Assessment(current: 0, maximum: 0);
    Assessment summativeTemp = new Assessment(current: 0, maximum: 0);

    try {
      formativeTemp.current = int.parse(currentFAController.text);
      formativeTemp.maximum = int.parse(maximumFAController.text);
      summativeTemp.current = int.parse(currentSAController.text);
      summativeTemp.maximum = int.parse(maximumSAController.text);

      if(formativeTemp.getPercentage() > 1.0 || summativeTemp.getPercentage() > 1.0) {
        throw Exception('Formative or Summative current value is more than maximum');
      }

      setState(() {
        formative = formativeTemp;
        summative = summativeTemp;

        error = false;
      });
    } catch (e) {
      setState(() {
        error = true;
      });
    }
  }

  @override
  initState() {
    super.initState();
    print(widget.routedData);
    currentFAController = new TextEditingController(text: '0')..addListener(dataChanged);
    maximumFAController = new TextEditingController(text: '40')..addListener(dataChanged);
    currentSAController = new TextEditingController(text: '0')..addListener(dataChanged);
    maximumSAController = new TextEditingController(text: '40')..addListener(dataChanged);
    if (widget.routedData.length != 0) {
      IMKOSubject subject = IMKOSubject.fromJson(json.decode(widget.routedData));
      formative = subject.formative;
      summative = subject.summative;

      currentFAController.text = formative.current.toString();
      maximumFAController.text = formative.maximum.toString();
      currentSAController.text = summative.current.toString();
      maximumSAController.text = summative.maximum.toString();
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
                  child: TextFieldRoundedEdges(
                    label: 'Current FA',
                    controller: currentFAController,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: TextFieldRoundedEdges(
                    label: 'Maximum FA',
                    controller: maximumFAController,
                  ),
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
                  child: TextFieldRoundedEdges(
                    label: 'Current SA',
                    controller: currentSAController,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: TextFieldRoundedEdges(
                    label: 'Maximum SA',
                    controller: maximumSAController,
                  ),
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
                        assessment: Assessment(current: (error)? 0 : Grade.calculateIMKOPoints(formative, summative), maximum: 60),
                        description: 'Total',
                      )),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: (error) ? null : Grade.calculateGradeColor(Grade.calculateIMKOPoints(formative, summative) / 60.0, Diary.imko),
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
                              (error) ? '-' : Grade.calculateGrade(Grade.calculateIMKOPoints(formative, summative) / 60.0, Diary.imko),
                              style: Theme.of(context).textTheme.body1.copyWith(
                                    fontSize: 24.0,
                                    color: Colors.white,
                                  ),
                            ),
                            Text(
                              (error)
                                  ? ''
                                  : '(${Grade.toNumericalGrade(
                                      Grade.calculateGrade(Grade.calculateIMKOPoints(formative, summative) / 60.0, Diary.imko),
                                    )})',
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
