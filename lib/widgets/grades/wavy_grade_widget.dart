import 'package:enis_new/classes/wave_clipper.dart';
import 'package:flutter/material.dart';

class WavyGradeWidget extends StatelessWidget {
  final Color color;
  final double percentage;
  final double maxHeight;
  final double animationValue;
  final String grade;

  WavyGradeWidget({this.color, this.percentage, this.maxHeight, this.animationValue = 1.0, this.grade});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(animationValue),
      child: Container(
        width: 64.0,
        height: (maxHeight * percentage * ((animationValue * 2 > 1.0) ? 1.0 : animationValue * 2)),
        color: color,
        child: Center(
          child: Text(
            (grade != '-')? grade : '',
            style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white, fontSize: 24.0, fontFamily: 'Futura', fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
