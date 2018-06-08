import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'user_data.dart';
import 'utils.dart';

class AccountAPI {
  /// This function gets the Session ID from cookies
  static Future<UserData> getSessionID(UserData loginData) async {
    try {
      //Prepare request data
      Map requestData = {"txtUsername": loginData.pin, "txtPassword": loginData.password};
      Map<String, String> headers = {"locale": loginData.language, "Culture": loginData.language};
      //Decode the data
      final response = await Utils.post(
        url: loginData.schoolURL + '/Account/Login',
        reqData: requestData,
        headers: headers,
      );
      final bodyData = json.decode(response.body);

      //If request was successful
      if (bodyData['success']) {
        //Extract session id from cookies
        String cookies = response.headers['set-cookie'];
        int schoolAuthIndex = cookies.indexOf('SchoolAuth');

        String schoolAuth = cookies.substring(
          schoolAuthIndex,
          cookies.indexOf(';', schoolAuthIndex),
        );

        //Set session id to our user data class
        loginData.sessionID = schoolAuth;

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
      Map requestData = {};
      //Decode the data
      final response = await Utils.post(
        url: loginData.schoolURL + '/Account/GetRoles',
        reqData: requestData,
        headers: loginData.generateHeaders(),
      );
      final bodyData = json.decode(response.body);

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
      Map requestData = {"role": loginData.role, "password": loginData.password};

      final response = await Utils.post(
        url: loginData.schoolURL + '/Account/LoginWithRole',
        reqData: requestData,
        headers: loginData.generateHeaders(),
      );
      final bodyData = json.decode(response.body);

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
      prefs.setString('user_data_role', data.role);

      return dataToReturn;
    } catch (Exception) {
      throw Exception;
    }
  }

  static Future<UserData> loginFromPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      UserData data;
      if (prefs.getString('user_data_role') == 'Student') {
        data = new StudentUserData.fromJSON(json.decode(prefs.getString('user_data')));
      }
      return login(data);
    } catch (Exception) {
      throw Exception;
    }
  }
}
