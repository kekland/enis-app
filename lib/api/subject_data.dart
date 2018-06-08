import 'quarter.dart';

class SubjectData {
  List<Quarter> quarters = new List(4);

  void setQuarter(int index, Quarter data) {
    quarters[index] = data;
  }

  void setQuarters(List<Quarter> data) {
    quarters = data;
  }
}
