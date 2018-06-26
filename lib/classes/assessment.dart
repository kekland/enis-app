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

  operator +(Assessment other) {
    this.current += other.current;
    this.maximum += other.maximum;
  }

  operator -(Assessment other) {
    this.current -= other.current;
    this.maximum -= other.maximum;
  }
  static Assessment lerp(Assessment assessment, double value) {
    int newCurrent = (assessment.current.toDouble() * value).round();
    int newMaximum = (assessment.maximum.toDouble() * value).round();
    return Assessment(current: newCurrent, maximum: newMaximum);
  }

  Map toJSON() {
    return {
      'current': current,
      'maximum': maximum,
    };
  }

  factory Assessment.fromJSON(Map json) {
    return Assessment(
      current: json['current'],
      maximum: json['maximum'],
    );
  }
}
