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
}
