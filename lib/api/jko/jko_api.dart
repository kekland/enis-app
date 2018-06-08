import 'dart:core';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../account_api.dart';
import '../user_data.dart';
import 'dart:convert';
import '../utils.dart';
import 'jko_data.dart';

class JKODiaryAPI {
  static Future<List<JKOSubject>> getSubjectsOnQuarter(quarter, [UserData userData]) async {
    if (userData == null) {
      userData = await AccountAPI.loginFromPrefs();
    }
    String link = await getLink(quarterID: quarter, userData: userData);
    String header = await openLink(link: link, userData: userData);

    getSubjectsWithLink(link, header, userData);
  }

  static Future<List<JKOSubject>> getSubjectsWithLink(String link, String header, UserData userData) async {
    Map params = {
      'page': '1',
      'start': '0',
      'limit': '100',
    };

    Map<String, String> headers = userData.generateHeaders();
    headers['Referer'] = link;
    headers['Cookie'] += '; ' + header;

    final response = await Utils.post(
      url: userData.schoolURL + '/Jce/Diary/GetSubjects',
      reqData: params,
      headers: headers,
    );

    final bodyData = json.decode(response.body);

    if (bodyData['success']) {
      String link = bodyData['data'];
      //yay
    } else {
      throw new Exception('Error when fetching subjects');
    }
  }

  static Future<String> openLink({String link, UserData userData}) async {
    final linkOpenResponse = await http.get(link, headers: userData.generateHeaders());

    String userSessionKey = linkOpenResponse.headers['set-cookie'];

    userSessionKey = userSessionKey.substring(userSessionKey.indexOf('UserSessionKey='));

    return userSessionKey;
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
        return link;
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
