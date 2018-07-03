import 'dart:convert';

import 'package:enis_new/api/imko/imko_data.dart';
import 'package:enis_new/classes/assessment.dart';
import 'package:enis_new/classes/diary.dart';
import 'package:enis_new/classes/grade.dart';
import 'package:enis_new/widgets/assessment_number_widget.dart';
import 'package:enis_new/widgets/calculator/imko_term_calculator_widget.dart';
import 'package:enis_new/widgets/calculator/jko_term_calculator_widget.dart';
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
    return TabBarView(
      children: [
        IMKOTermCalculatorWidget(routedData: (widget.routedIndex == 0) ? widget.routedData : ''),
        JKOTermCalculatorWidget(routedData: (widget.routedIndex == 1) ? widget.routedData : ''),
        Container(child: Center(child: Text('In development'))),
        Container(child: Center(child: Text('In development'))),
      ],
    );
  }
}