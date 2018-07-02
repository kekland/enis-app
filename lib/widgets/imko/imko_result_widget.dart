import 'package:enis_new/api/imko/imko_data.dart';
import 'package:enis_new/api/subject.dart';
import 'package:enis_new/classes/assessment.dart';
import 'package:enis_new/classes/diary.dart';
import 'package:enis_new/classes/grade.dart';
import 'package:enis_new/widgets/grade_widget.dart';
import 'package:flutter/material.dart';

class IMKOResultWidget extends StatefulWidget {
  final List<IMKOSubject> subjects;

  double calculatePercentage() {
    Assessment formativeTotal = new Assessment(current: 0, maximum: 0);
    Assessment summativeTotal = new Assessment(current: 0, maximum: 0);
    subjects.forEach((IMKOSubject subject) {
      formativeTotal += subject.formative;
      summativeTotal += subject.summative;
    });
    return (formativeTotal.getPercentage() * 18.0 + summativeTotal.getPercentage() * 42.0) / 60.0;
  }

  Color calculateGradeColor() {
    String numericGrade = Grade.toNumericalGrade(Grade.calculateGrade(calculatePercentage(), Diary.imko));
    switch (numericGrade) {
      case '5':
        return Colors.green;
      case '4':
        return Colors.amber;
      case '3':
        return Colors.deepOrange;
      case '2':
        return Colors.red;
      default:
        return Colors.black12;
    }
  }

  IMKOResultWidget({this.subjects});
  @override
  _IMKOResultWidgetState createState() => _IMKOResultWidgetState();
}

class _IMKOResultWidgetState extends State<IMKOResultWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          bottom: 16.0,
          top: 16.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      widget.subjects[0].name,
                      style: Theme.of(context).textTheme.body1.copyWith(fontSize: 20.0, fontFamily: 'Futura', fontWeight: FontWeight.w400),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: widget.subjects.map((IMKOSubject s) {
                      return GradeWidget(
                        viewModel: GradeWidgetViewModel(
                          grade: s.calculateGrade(),
                          gradeColor: s.calculateGradeColor(),
                          percentage: s.calculateGradePercentage(),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Container(
              width: 96.0,
              child: Center(
                child: Text(
                  Grade.calculateGrade(widget.calculatePercentage(), Diary.imko),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.body1.copyWith(
                        fontSize: 40.0,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                        color: widget.calculateGradeColor(),
                      ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
