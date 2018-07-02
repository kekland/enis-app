import 'dart:convert';

import 'package:enis_new/api/imko/imko_data.dart';
import 'package:enis_new/classes/assessment.dart';
import 'package:enis_new/classes/diary.dart';
import 'package:enis_new/classes/grade.dart';
import 'package:enis_new/pages/calculator_page.dart';
import 'package:enis_new/widgets/assessment_number_widget.dart';
import 'package:enis_new/widgets/calculator/rounded_text_field.dart';
import 'package:flutter/material.dart';

class IMKOTermCalculatorWidget extends StatefulWidget {
  final String routedData;
  IMKOTermCalculatorWidget({this.routedData = ''});
  @override
  IMKOTermCalculatorWidgetState createState() {
    return new IMKOTermCalculatorWidgetState();
  }
}

class IMKOTermCalculatorWidgetState extends State<IMKOTermCalculatorWidget> {
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

      if (formativeTemp.getPercentage() > 1.0 || summativeTemp.getPercentage() > 1.0) {
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

      currentFAController = new TextEditingController(text: formative.current.toString())..addListener(dataChanged);
      maximumFAController = new TextEditingController(text: formative.maximum.toString())..addListener(dataChanged);
      currentSAController = new TextEditingController(text: summative.current.toString())..addListener(dataChanged);
      maximumSAController = new TextEditingController(text: summative.maximum.toString())..addListener(dataChanged);
    } else {
      currentFAController = new TextEditingController(text: '0')..addListener(dataChanged);
      maximumFAController = new TextEditingController(text: '40')..addListener(dataChanged);
      currentSAController = new TextEditingController(text: '0')..addListener(dataChanged);
      maximumSAController = new TextEditingController(text: '40')..addListener(dataChanged);
    }

    dataChanged();
  }

  onEditButtonPress(String type, int delta) {
    switch (type) {
      case 'formative_current':
        try {
          int value = int.parse(currentFAController.text);
          currentFAController.text = (value + delta).toString();
        } catch (e) {}
        break;
      case 'formative_maximum':
        try {
          int value = int.parse(maximumFAController.text);
          maximumFAController.text = (value + delta).toString();
        } catch (e) {}
        break;
      case 'summative_current':
        try {
          int value = int.parse(currentSAController.text);
          currentSAController.text = (value + delta).toString();
        } catch (e) {}
        break;
      case 'summative_maximum':
        try {
          int value = int.parse(maximumSAController.text);
          maximumSAController.text = (value + delta).toString();
        } catch (e) {}
        break;
    }

    dataChanged();
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
                  child: RoundedTextField(
                    label: 'Current FA',
                    controller: currentFAController,
                    onIncrementPressed: () => onEditButtonPress('formative_current', 1),
                    onDecrementPressed: () => onEditButtonPress('formative_current', -1),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: RoundedTextField(
                    label: 'Maximum FA',
                    controller: maximumFAController,
                    onIncrementPressed: () => onEditButtonPress('formative_maximum', 1),
                    onDecrementPressed: () => onEditButtonPress('formative_maximum', -1),
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
                  child: RoundedTextField(
                    label: 'Current SA',
                    controller: currentSAController,
                    onIncrementPressed: () => onEditButtonPress('summative_current', 1),
                    onDecrementPressed: () => onEditButtonPress('summative_current', -1),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: RoundedTextField(
                    label: 'Maximum SA',
                    controller: maximumSAController,
                    onIncrementPressed: () => onEditButtonPress('summative_maximum', 1),
                    onDecrementPressed: () => onEditButtonPress('summative_maximum', -1),
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
                      child: AssessmentCurrentMaximumWidget(
                        assessment: Assessment(current: (error) ? 0 : Grade.calculateIMKOPoints(formative, summative), maximum: 60),
                        description: 'Total',
                      ),
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
