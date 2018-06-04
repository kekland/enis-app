class Assessment {
  int current;
  int maximum;

  double getPercentage() {
    return current.toDouble() / maximum.toDouble();
  }

  Assessment({this.current, this.maximum});
}
