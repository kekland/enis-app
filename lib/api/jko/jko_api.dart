import 'dart:core';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:enis_new/api/account_api.dart';
import 'dart:convert';

import 'package:enis_new/api/jko/jko_data.dart';
import 'package:enis_new/api/quarter.dart';
import 'package:enis_new/api/user_data.dart';
import 'package:enis_new/api/utils.dart';

class JKODiaryAPI {
  static Future<List<JKOAssessment>> getAssessments(JKOSubject subject, [UserData userData]) async {
    if (userData == null) {
      userData = await AccountAPI.loginFromPrefs();
    }

    List topicJson = await getAssessmentOnEvaluation(subject.diaryId, subject.evaluations[0], userData);
    List quarterJson = await getAssessmentOnEvaluation(subject.diaryId, subject.evaluations[1], userData);

    List<JKOAssessment> assessments = new List();
    for (int i = 0; i < topicJson.length; i++) {
      Map topic = topicJson[i];
      Map quarter = quarterJson[i];
      assessments.add(new JKOAssessment.fromApiJson(topic, quarter));
    }
    return assessments;
  }

  static Future<List> getAssessmentOnEvaluation(String journalEvalID, JKOSubjectEvaluation evaluation, [UserData userData]) async {
    if (userData == null) {
      userData = await AccountAPI.loginFromPrefs();
    }

    Dio dio = await Utils.createDioInstance(userData.schoolURL);
    Map requestParams = {
      'evalId': evaluation.evaluationID,
      'journalId': journalEvalID,
      'page': '1',
      'start': '0',
      'limit': '100',
    };

    Response response = await dio.post('/Jce/Diary/GetResultByEvalution', data: requestParams);

    Map data = json.decode(response.data);
    if (data['success']) {
      return data['data'];
      //good
    } else {
      throw Exception('Error occurred while fetching assessment data');
    }
  }

  static Future<Null> getAllJkoSubjectsCallback(Function callback, [UserData userData]) async {
    try {
      if (userData == null) {
        userData = await AccountAPI.loginFromPrefs();
      }

      for (int quarterIndex = 1; quarterIndex <= 4; quarterIndex++) {
        callback(quarterIndex - 1, await getSubjectsOnQuarter(quarterIndex, userData));
      }
    } catch (Exception) {
      throw Exception;
    }
  }

  static Future<Quarter> getSubjectsOnQuarter(quarter, [UserData userData]) async {
    if (userData == null) {
      userData = await AccountAPI.loginFromPrefs();
    }
    String link = await getLink(quarterID: quarter, userData: userData);
    String header = await openLink(link: link, userData: userData);

    return await getSubjectsWithLink(link, header, quarter, userData);
  }

  static Future<Quarter> getSubjectsWithLink(String link, String header, int quarter, UserData userData) async {
    Dio dio = await Utils.createDioInstance(userData.schoolURL);

    Map params = {
      'page': '1',
      'start': '0',
      'limit': '100',
    };

    final response = await dio.post(
      userData.schoolURL + '/Jce/Diary/GetSubjects',
      data: params,
      options: Options(
        responseType: ResponseType.JSON,
      ),
    );

    final bodyData = json.decode(response.data);

    List<JKOSubject> list = new List();
    if (bodyData['success']) {
      for (Map item in bodyData['data']) {
        list.add(new JKOSubject.fromApiJson(item));
      }
      list.forEach((JKOSubject subject) {
        subject.quarter = quarter;
      });
      return new Quarter(subjects: list);
    } else {
      throw new Exception('Error when fetching subjects');
    }
  }

  static Future<Null> openLink({String link, UserData userData}) async {
    Dio dio = await Utils.createDioInstance(userData.schoolURL);
    final linkOpenResponse = await dio.get(
      link,
      data: {},
    );
  }

  static Future<String> getLink({int quarterID, UserData userData}) async {
    if (userData == null) {
      userData = await AccountAPI.loginFromPrefs();
    }

    Dio dio = await Utils.createDioInstance(userData.schoolURL);

    if (userData.runtimeType == StudentUserData) {
      IDData userID = await getStudentData(userData);
      Map requestData = {
        'periodId': quarterID.toString(),
        'studentId': userID.studentID,
        'klassId': userID.classID,
      };

      final response = await dio.post(
        userData.schoolURL + '/JCEDiary/GetDiaryURL',
        data: requestData,
      );

      final bodyData = response.data;

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
    Dio dio = await Utils.createDioInstance(userData.schoolURL);
    if (userData == null) {
      userData = await AccountAPI.loginFromPrefs();
    }

    final response = await dio.post(userData.schoolURL + '/JceDiary/JceDiary', data: {}, options: Options(responseType: ResponseType.PLAIN));

    return parseStudentData(response.data);
  }
}
