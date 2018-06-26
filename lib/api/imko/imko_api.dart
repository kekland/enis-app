import 'dart:async';

import 'package:dio/dio.dart';
import 'package:enis_new/api/account_api.dart';
import 'package:enis_new/api/imko/imko_data.dart';
import 'package:enis_new/api/quarter.dart';
import 'package:enis_new/api/subject_data.dart';
import 'package:enis_new/api/user_data.dart';
import 'package:enis_new/api/utils.dart';

class IMKODiaryAPI {
  static Future<SubjectData> getAllImkoSubjects([UserData userData]) async {
    try {
      SubjectData data = new SubjectData();

      if (userData == null) {
        userData = await AccountAPI.loginFromPrefs();
      }
      for (int quarterIndex = 1; quarterIndex <= 4; quarterIndex++) {
        data.setQuarter(quarterIndex - 1, await getSubjectData(userData, quarterIndex));
      }

      return data;
    } catch (Exception) {
      throw Exception;
    }
  }

  static Future<Null> getAllImkoSubjectsCallback(Function callback, [UserData userData]) async {
    try {
      if (userData == null) {
        userData = await AccountAPI.loginFromPrefs();
      }

      for (int quarterIndex = 1; quarterIndex <= 4; quarterIndex++) {
        callback(quarterIndex - 1, await getSubjectData(userData, quarterIndex));
      }
    } catch (Exception) {
      throw Exception;
    }
  }

  static Future<Quarter> getSubjects(int quarterIndex, [UserData userData]) async {
    try {
      if (userData == null) {
        userData = await AccountAPI.loginFromPrefs();
      }
      return getSubjectData(userData, quarterIndex);
    } catch (Exception) {
      throw Exception;
    }
  }

  static Future<Quarter> getSubjectData(UserData userData, int quarterIndex) async {
    try {
      Dio dio = await Utils.createDioInstance(userData.schoolURL);

      Map requestData = {"periodId": quarterIndex.toString()};

      final response = await dio.post(
        '/ImkoDiary/Subjects',
        data: requestData,
      );
      Map bodyData = response.data;

      if (bodyData['success']) {
        List subjects = bodyData['data'];
        List<IMKOSubject> list = subjects.map((obj) => IMKOSubject.fromApiJson(obj, quarterIndex)).toList();
        return new Quarter(subjects: list);
      } else {
        throw new Exception('Failure when fetching subjects');
      }
    } catch (Exception) {
      throw Exception;
    }
  }

  static Future<List<IMKOGoalGroup>> getGoals(int quarterIndex, int subjectIndex, [UserData userData]) async {
    if (userData == null) {
      userData = await AccountAPI.loginFromPrefs();
    }
    return getGoalsData(userData, quarterIndex, subjectIndex);
  }

  static List<IMKOGoalGroup> apiJsonToGoalGroupList(List data) {
    try {
      List<IMKOGoalGroup> goalGroups = new List();

      int previousGroupIndex = -1;
      for (Map item in data) {
        int groupIndex = item['GroupIndex'];
        if (groupIndex != previousGroupIndex) {
          previousGroupIndex = groupIndex;
          goalGroups.add(
            new IMKOGoalGroup(groupName: item['GroupName'], goals: new List()),
          );
        }
        goalGroups[goalGroups.length - 1].goals.add(new IMKOGoal.fromApiJson(item));
      }
      return goalGroups;
    } catch (Exception) {
      throw Exception;
    }
  }

  static Future<List<IMKOGoalGroup>> getGoalsData(UserData userData, int quarterIndex, int subjectIndex) async {
    try {
      Dio dio = await Utils.createDioInstance(userData.schoolURL);

      Map requestData = {
        "periodId": quarterIndex.toString(),
        "subjectId": subjectIndex.toString(),
      };

      final response = await dio.post(
        userData.schoolURL + '/ImkoDiary/Goals',
        data: requestData,
      );
      Map bodyData = response.data;

      if (bodyData['success']) {
        List data = bodyData['data']['goals'];

        return apiJsonToGoalGroupList(data);
      } else {
        throw new Exception('Failure when fetching goals');
      }
    } catch (Exception) {
      throw Exception;
    }
  }
}
