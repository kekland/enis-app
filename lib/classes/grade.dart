import 'assessment.dart';
import 'diary.dart';

class Grade {
  static const String APlus = "A+";
  static const String A = "A";
  static const String B = "B";
  static const String C = "C";
  static const String D = "D";
  static const String E = "E";
  static const String F = "F";

  static String toNumericalGrade(String grade) {
    switch (grade) {
      case APlus:
        return '5';
      case A:
        return '5';
      case B:
        return '4';
      case C:
        return '4';
      case D:
        return '3';
      case E:
        return '3';
      case F:
        return '2';
      default:
        return '-';
    }
  }

  static int calculateIMKOPoints(Assessment formative, Assessment summative) {
    return (formative.getPercentage() * 18.0 + summative.getPercentage() * 42.0).round();
  }

  static String calculateIMKOGrade(Assessment formative, Assessment summative) {
    return calculateGrade(calculateIMKOPoints(formative, summative).toDouble() / 60.0, Diary.imko);
  }

  //TODO: Fix percentage calculation and rounding
  static String calculateGrade(double percentage, Diary diary) {
    //64.92
    //->65
    if (diary == Diary.imko) {
      if (percentage >= 0.9)
        return APlus;
      else if (percentage >= 0.8)
        return A;
      else if (percentage >= 0.7)
        return B;
      else if (percentage >= 0.6)
        return C;
      else if (percentage >= 0.5)
        return D;
      else if (percentage >= 0.4)
        return E;
      else
        return F;
    } else {
      percentage = (percentage * 100.0).roundToDouble() / 100.0;
      if (percentage >= 0.9)
        return APlus;
      else if (percentage >= 0.85)
        return A;
      else if (percentage >= 0.7)
        return B;
      else if (percentage >= 0.65)
        return C;
      else if (percentage >= 0.5)
        return D;
      else if (percentage >= 0.4)
        return E;
      else
        return F;
    }
  }
}
