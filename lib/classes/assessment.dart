class Assessment {
  int current;
  int maximum;

  double getPercentage() {
    if (maximum == 0) {
      return 1.0;
    }
    return current.toDouble() / maximum.toDouble();
  }

  Assessment({this.current, this.maximum});

  static Assessment lerp(Assessment assessment, double value) {
    int newCurrent = (assessment.current.toDouble() * value).round();
    int newMaximum = (assessment.maximum.toDouble() * value).round();
    return Assessment(current: newCurrent, maximum: newMaximum);
  }
}
