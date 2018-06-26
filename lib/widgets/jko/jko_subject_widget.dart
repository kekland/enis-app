import 'package:enis_new/api/jko/jko_data.dart';
import 'package:enis_new/classes/diary.dart';
import 'package:enis_new/classes/grade.dart';
import 'package:enis_new/widgets/assessment_number_widget.dart';
import 'package:enis_new/widgets/grade_widget.dart';
import 'package:enis_new/widgets/jko/jko_subject_detail_widget.dart';
import 'package:flutter/material.dart';

class JKOSubjectViewModel {
  JKOSubject subject;

  double getPercentageToDisplay() {
    return subject.points * 100.0;
  }


  JKOSubjectViewModel({this.subject});
}

class JKOSubjectWidget extends StatelessWidget {
  final JKOSubjectViewModel viewModel;
  final bool tappable;
  final Animation<double> animation;
  JKOSubjectWidget({
    this.viewModel,
    this.tappable = true,
    this.animation = const AlwaysStoppedAnimation(1.0),
  });

  onCardTap(BuildContext ctx) {
    Navigator.of(ctx).push(
      new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new JKOSubjectDetailPage(
            viewModel: viewModel,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget cardChild = new Container(
      padding: EdgeInsets.all(16.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          new Expanded(
            child: Text(
              viewModel.subject.name,
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 20.0, fontFamily: 'Futura', fontWeight: FontWeight.w400),
            ),
          ),
          new Row(
            children: <Widget>[
              new AsssesmentPercentWidget(
                viewModel: new AssessmentPercentViewModel(
                  percentage: viewModel.getPercentageToDisplay(),
                  description: '%',
                ),
                animationValue: animation.value,
              ),
              new Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: new GradeWidget(
                  viewModel: new GradeWidgetViewModel(
                    grade: viewModel.subject.calculateGrade(),
                    gradeColor: viewModel.subject.calculateGradeColor(),
                    percentage: 0.85,
                  ),
                  animationValue: animation.value,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (tappable) {
      return new Hero(
        tag: 'jko.${viewModel.subject.quarter}.${viewModel.subject.name}.heroWidget',
        child: new Opacity(
          opacity: animation.value,
          child: new Card(
            child: new InkWell(
              onTap: () => onCardTap(context),
              child: cardChild,
            ),
          ),
        ),
      );
    } else {
      return new Hero(
        tag: 'jko.${viewModel.subject.quarter}.${viewModel.subject.name}.heroWidget',
        child: Opacity(
          opacity: animation.value,
          child: Card(
            child: cardChild,
          ),
        ),
      );
    }
  }
}
