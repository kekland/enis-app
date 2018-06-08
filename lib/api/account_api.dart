import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'utils.dart';
import 'package:cookie_jar/cookie_jar.dart';
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
}
