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

  displayDialogForFormative(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: ((BuildContext context) {
        TextEditingController currentController = new TextEditingController(text: formative.current.toString());
        currentController.addListener(() {
          try {
            formative.current = int.tryParse(currentController.text);
          } catch (e) {
            //ignore
          }
        });
        TextEditingController maximumController = new TextEditingController(text: formative.maximum.toString());
        maximumController.addListener(() {
          try {
            formative.maximum = int.tryParse(maximumController.text);
          } catch (e) {
            //ignore
          }
        });
        return new AlertDialog(
          title: Text('Change formative marks'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Current formative points'),
                keyboardType: TextInputType.number,
                controller: currentController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Maximum formative points'),
                keyboardType: TextInputType.number,
                controller: maximumController,
              ),
            ],
          ),
        );
      }),
    );
  }

  displayDialogForSummative(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: ((BuildContext context) {
        TextEditingController currentController = new TextEditingController(text: summative.current.toString());
        currentController.addListener(() {
          try {
            summative.current = int.tryParse(currentController.text);
          } catch (e) {
            //ignore
          }
        });
        TextEditingController maximumController = new TextEditingController(text: summative.maximum.toString());
        maximumController.addListener(() {
          try {
            summative.maximum = int.tryParse(maximumController.text);
          } catch (e) {
            //ignore
          }
        });
        return new AlertDialog(
          title: Text('Change summative marks'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Current summative points'),
                keyboardType: TextInputType.number,
                controller: currentController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Maximum summative points'),
                keyboardType: TextInputType.number,
                controller: maximumController,
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: new SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: new InkWell(
                onTap: () => displayDialogForFormative(context),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Formative'),
                      AssessmentCurrentMaximumWidget(
                        AssessmentCurrentMaximumViewModel(assessment: formative, description: 'FA'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: new InkWell(
                onTap: () => displayDialogForSummative(context),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Summative'),
                      AssessmentCurrentMaximumWidget(
                        AssessmentCurrentMaximumViewModel(assessment: summative, description: 'SA'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: new Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Results'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Text(
                          Grade.calculateIMKOGrade(formative, summative),
                          style: Theme.of(context).textTheme.body1.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 40.0,
                                color: Grade.calculateGradeColor(
                                  Grade.calculateIMKOPoints(formative, summative) / 60.0,
                                  Diary.imko,
                                ),
                              ),
                        ),
                        Text(
                          Grade.toNumericalGrade(Grade.calculateIMKOGrade(formative, summative)),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                fontSize: 24.0,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
