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

  String language = 'en-US';

  Map toJSON();
  String role;
}

class UnknownUserData implements UserData {
  String pin;
  String password;
  String schoolURL;
  String role = 'Unknown';

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

  UnknownUserData({
    this.pin,
    this.password,
    this.schoolURL,
    this.language = 'en-US',
  });

  factory UnknownUserData.fromUserData(UserData data) {
    return UnknownUserData(
      pin: data.pin,
      password: data.password,
      schoolURL: data.schoolURL,
      language: data.language,
    );
  }

  factory UnknownUserData.fromJSON(Map json) {
    UnknownUserData data = new UnknownUserData(
      pin: json['pin'],
      password: json['password'],
      schoolURL: json['schoolURL'],
      language: json['language'],
    );
    return data;
  }
}
class StudentUserData implements UserData {
  String pin;
  String password;
  String schoolURL;
  String role = 'Student';
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

  factory StudentUserData.fromUserData(UserData data) {
    return StudentUserData(
      pin: data.pin,
      password: data.password,
      schoolURL: data.schoolURL,
      language: data.language,
    );
  }

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
