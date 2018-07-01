import 'dart:convert';

import 'package:enis_new/api/imko/imko_data.dart';
import 'package:enis_new/classes/assessment.dart';
import 'package:enis_new/classes/diary.dart';
import 'package:enis_new/classes/grade.dart';
import 'package:enis_new/widgets/assessment_number_widget.dart';
import 'package:enis_new/widgets/calculator/imko_term_calculator_widget.dart';
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
          IMKOTermCalculatorWidget(routedData: (widget.routedIndex == 0) ? widget.routedData : ''),
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