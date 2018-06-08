import 'dart:core';
import 'dart:async';
import '../account_api.dart';
import '../user_data.dart';
import 'dart:convert';
import '../utils.dart';

class JKODiaryAPI {
  static Future<String> loadLink(String link, [UserData userData]) async {
    await Utils.post(
      url: link,
      reqData: null,
      headers: userData.generateHeaders(),
    );

    return link;
  }

  static Future<String> getLink({int quarterID, UserData userData}) async {
    if (userData == null) {
      userData = await AccountAPI.loginFromPrefs();
    }

    if (userData.runtimeType == StudentUserData) {
      IDData userID = await getStudentData(userData);
      Map requestData = {
        'periodId': quarterID.toString(),
        'studentId': userID.studentID,
        'klassId': userID.classID,
      };

      final response = await Utils.post(
        url: userData.schoolURL + '/JCEDiary/GetDiaryURL',
        headers: userData.generateHeaders(),
        reqData: requestData,
      );

      final bodyData = json.decode(response.body);

      if (bodyData['success']) {
        String link = bodyData['data'];
        return await loadLink(link, userData);
      } else {
        throw new Exception('Error when fetching link');
      }
    } else {
      //idk
      return 'err';
    }
  }

  static IDData parseStudentData(String body) {
    IDData result = new IDData();

    int indexStudent = body.indexOf('student: {');
    int indexColon = body.indexOf(':', indexStudent + 8);
    int indexComma = body.indexOf(',', indexColon);

    result.studentID = body.substring(indexColon + 1, indexComma);

    int indexClass = body.indexOf('klass: {');
    indexColon = body.indexOf(':', indexClass + 6);
    indexComma = body.indexOf(',', indexClass);

    result.classID = body.substring(indexColon + 1, indexComma);

    return result;
  }

  static Future<IDData> getStudentData([UserData userData]) async {
    if (userData == null) {
      userData = await AccountAPI.loginFromPrefs();
    }

    final response = await Utils.post(
      url: userData.schoolURL + '/JceDiary/JceDiary',
      reqData: null,
      headers: userData.generateHeaders(),
    );

    return parseStudentData(response.body);
  }
}
