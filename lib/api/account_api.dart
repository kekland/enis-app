import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:enis_new/api/user_birthday_data.dart';

import 'utils.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_data.dart';

class AccountAPI {
  /// This function gets the Session ID from cookies
  static Future<UserData> getSessionID(UserData loginData) async {
    try {
      Dio dio = await Utils.createDioInstance(loginData.schoolURL);

      dio.cookieJar.saveFromResponse(Uri.parse(loginData.schoolURL), [
        new Cookie('locale', loginData.language),
        new Cookie('Culture', loginData.language),
      ]);

      Map requestData = {"txtUsername": loginData.pin, "txtPassword": loginData.password};
      //Decode the data
      Response response = await dio.post(
        '/Account/Login',
        data: requestData,
      );

      final bodyData = response.data;

      //If request was successful
      if (bodyData['success']) {
        return loginData;
      } else {
        //If request was unsuccessful - throw exception
        throw new Exception('Invalid credentials');
      }
    } catch (Exception) {
      throw Exception;
    }
  }

  static Future<UserData> getRoles(UserData loginData) async {
    try {
      Dio dio = await Utils.createDioInstance(loginData.schoolURL);

      //Decode the data
      Response response = await dio.post(
        '/Account/GetRoles',
        data: {},
      );

      final bodyData = response.data;

      if (bodyData['success']) {
        List roles = bodyData['listRole'];
        String selectedRoleValue;

        for (Map role in roles) {
          if (role['value'].toString() == 'Student') {
            selectedRoleValue = 'Student';
          }
        }

        if (selectedRoleValue == 'Student') {
          return new StudentUserData.fromUserData(loginData);
        } else {
          throw new Exception('Your role is unsupported');
        }
      } else {
        throw new Exception('Invalid credentials');
      }
    } catch (Exception) {
      throw Exception;
    }
  }

  static Future<UserData> confirmLogin(UserData loginData) async {
    try {
      Dio dio = await Utils.createDioInstance(loginData.schoolURL);

      Map requestData = {"role": loginData.role, "password": loginData.password};

      Response response = await dio.post(
        '/Account/LoginWithRole',
        data: requestData,
      );
      final bodyData = response.data;

      if (bodyData['success']) {
        return loginData;
      } else {
        throw new Exception('Invalid credentials');
      }
    } catch (Exception) {
      throw Exception;
    }
  }

  static Future<UserData> login(UserData data) async {
    try {
      UserData dataToReturn;

      await getSessionID(data)
          .then((UserData loginData) => getRoles(loginData))
          .then((UserData loginData) => confirmLogin(loginData))
          .then((UserData finalData) => dataToReturn = finalData)
          .catchError((e) {
        print(e);
        throw (e);
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('user_data', json.encode(dataToReturn.toJSON()));
      prefs.setString('user_data_role', dataToReturn.role);
      prefs.setBool('user_log_in_at_next_time', true);

      return dataToReturn;
    } catch (Exception) {
      throw Exception;
    }
  }

  static Future<UserData> loginFromPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      UserData data;
      String userRole = prefs.getString('user_data_role');
      if (userRole == 'Student') {
        data = new StudentUserData.fromJSON(json.decode(prefs.getString('user_data')));
      }
      return login(data);
    } catch (Exception) {
      throw Exception;
    }
  }

  static List rolesToLoad = [
    'Student',
    'Teacher',
    'ClassHeader',
  ];
  static Future<List<UserBirthdayData>> getBirthdays([UserData userData]) async {
    if (userData == null) {
      userData = await AccountAPI.loginFromPrefs();
    }
    try {
      Dio dio = await Utils.createDioInstance(userData.schoolURL);
      List<UserBirthdayData> data = [];
      for (String role in rolesToLoad) {
        Map requestData = {
          'sort': 'SecondName',
          'dir': 'ASC',
          'filter': '',
          'start': 0,
          'limit': 20000,
          'role': role,
        };

        final response = await dio.post(
          userData.schoolURL + '/Management/GetPersons/',
          data: requestData,
        );
        Map bodyData = response.data;
        for (Map dat in bodyData['data']) {
          data.add(new UserBirthdayData(
            name: dat['FirstName'],
            surname: dat['SecondName'],
            role: role,
            birthday: parseDate(dat['Birthday']),
          ));
        }
      }
      return data;
    } catch (e) {
      throw e;
    }
  }

  static DateTime parseDate(String date) {
    List<String> spl = date.split('-');
    int year = int.parse(spl[0]);
    int month = int.parse(spl[1]);
    int day = int.parse(spl[2].substring(0, 2));
    return new DateTime(year, month, day);
  }
}
