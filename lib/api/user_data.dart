import '../classes/school.dart';

class IDData {
  String studentID;
  String classID;

  IDData({this.studentID, this.classID});

  Map toJSON() {
    return <String, String>{'studentID': studentID, 'classID': classID};
  }

  factory IDData.fromJSON(Map json) {
    return new IDData(
      studentID: json['studentID'],
      classID: json['classID'],
    );
  }
}

abstract class UserData {
  String pin;
  String password;
  String schoolURL;

  String sessionID = '';
  String language = 'en-US';

  Map toJSON();
}

class StudentUserData implements UserData {
  String pin;
  String password;
  String schoolURL;

  String sessionID = '';
  String language = 'en-US';

  @override
  Map toJSON() {
    return <String, dynamic>{
      'pin': pin,
      'password': password,
      'schoolURL': schoolURL,
      'language': language,
    };
  }

  StudentUserData({
    this.pin,
    this.password,
    this.schoolURL,
    this.language = 'en-US',
  });

  factory StudentUserData.fromJSON(Map json) {
    StudentUserData data = new StudentUserData(
      pin: json['pin'],
      password: json['password'],
      schoolURL: json['schoolURL'],
      language: json['language'],
    );
    return data;
  }
}
