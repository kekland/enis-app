import 'package:enis_new/api/imko/imko_api.dart';
import 'package:enis_new/api/imko/imko_data.dart';
import 'package:enis_new/api/jko/jko_api.dart';
import 'package:enis_new/api/quarter.dart';
import 'package:enis_new/api/subject_data.dart';
import 'package:enis_new/classes/assessment.dart';
import 'package:enis_new/widgets/grades/imko/imko_subject_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GradesPage extends StatefulWidget {
  @override
  _GradesPageState createState() => _GradesPageState();
}

var items = [
  IMKOSubject.createNew(
      name: 'English', formative: Assessment(current: 10, maximum: 12), summative: Assessment(current: 20, maximum: 24), quarter: 1, grade: '4'),
  IMKOSubject.createNew(
      name: 'Russian Language', formative: Assessment(current: 3, maximum: 12), summative: Assessment(current: 15, maximum: 24), quarter: 1, grade: '4'),
  IMKOSubject.createNew(
      name: 'Kazakhstan In Modern World', formative: Assessment(current: 5, maximum: 12), summative: Assessment(current: 18, maximum: 24), quarter: 1, grade: '4'),
  IMKOSubject.createNew(
      name: 'Mathematics', formative: Assessment(current: 7, maximum: 12), summative: Assessment(current: 0, maximum: 24), quarter: 1, grade: '4'),
  IMKOSubject.createNew(
      name: 'Physical Education', formative: Assessment(current: 1, maximum: 12), summative: Assessment(current: 17, maximum: 24), quarter: 1, grade: '4')
];
var quarters = [1, 2, 3, 4];
SubjectData data = new SubjectData();

class _GradesPageState extends State<GradesPage> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
        children: quarters.map((var index) {
      return TermPage();
    }).toList());
  }
}

class TermPage extends StatefulWidget {
  @override
  _TermPageState createState() => _TermPageState();
}

class _TermPageState extends State<TermPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int itemIndex) {
        return IMKOSubjectWidget(
          subject: items[itemIndex],
        );
      },
    );
  }
}
