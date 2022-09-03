import 'dart:async';
import 'dart:convert';
import 'dart:developer';
//
import 'package:flutter/material.dart';
import 'package:restaurant_owner_app/models/localStorage.dart';

import './API/apiKey.dart';
import './http_exception.dart';
import '../user.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  // ignore: slash_for_doc_comments
  /**
  *? Functions

  *!-------
  ** get token
  * * get userId
  *!-------
  * * _authenticate   //?@param String email, String password,String apiKey,
  **  login   //?@param String email, String password
  ** signup //?@param User user
  ** tryAutoLogin
  **  _autoLogout
  **  logout
  **  setUserInfo //?@param String phoneNumber, String userName
  ** getUserInfo
  ** updateUserInfo(String userName, String phoneNumber)
  *# updateUserInfo(String userName, String phoneNumber)
  *!--------
  */

  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  static const String authUserData = "authUserData";
  static const String authUserInfo = "authUserInfo";
  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
    String email,
    String password,
    String apiKey,
  ) async {
    final url = Uri.parse(apiKey);
    email = email.toLowerCase();
    try {
      log('url $url');
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      _autoLogout();
      Timer(const Duration(seconds: 2), () async {
        Map info = await getUserInfo();

        await LocalStorage().saveAuthUserInfoInLocalStorage(info);

        log("restaurant info ${info['restaurantInfo']['isActive']}");
        // if (info['email'] == null) {
        //   log('\n\n nulllllllllllllllllll\n\n');
        //   _token = null;
        //   // throw Error();
        //   throw HttpException('This is not a restaurant account');
        // }
      });
      // await saveAuthUserDataInLocalStorage(
      //   token,
      //   userId,
      //   _expiryDate,
      // );
      await LocalStorage().saveAuthUserDataInLocalStorage(
        token!,
        userId!,
        _expiryDate!,
      );
      notifyListeners();

      // await saveAuthUserDataInLocalStorage();

    } catch (error) {
      log('Error auth file authenticate function $error');
      throw error;
    }
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse(Apikey().login);
    await _authenticate(email, password, (Apikey().login));
  }

  Future<void> signup(User user) async {
    await _authenticate(user.email, user.password, (Apikey().signup));
    await setUserInfo(user.name, user.phoneNumber, user.email);
  }

  Future<bool> tryAutoLogin() async {
    log('trying to login ');

    //? Attempt to auto-login

    // final prefs = await SharedPreferences.getInstance();
    // if (!prefs.containsKey(authUserData)) {
    //   // ! Auto login failed
    //   log('Auto login failed');
    //   return false;
    // }

    // final extractedUserData =
    // json.decode(prefs.getString(authUserData).toString()) as Map;
    // log('extractedUserData ${extractedUserData.toString()}');
    final expiryDate = DateTime.parse(LocalStorage().expiryDate.toString());
    if (expiryDate.isBefore(DateTime.now())) {
      // ! Auto login failed
      log('Auto login failed');
      return false;
    }
    _token = LocalStorage().token.toString();
    _userId = LocalStorage().userId.toString();
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    log('successfully logged in');
    return true;
  }

  void logout() {
    _token = null;
    _expiryDate = null;
    _userId = null;
    notifyListeners();
    LocalStorage().removeLocalStorage();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> setUserInfo(
    String name,
    String phoneNumber,
    String email,
  ) async {
    try {
      String api = await Apikey().userInfo;

      final url = Uri.parse(api.toString());
      var body = json.encode(
        {
          "userName": name,
          "email": email,
          "phoneNumber": phoneNumber,
          "restaurantInfo": {
            "isActive": "false",
            "name": "",
            "address": "",
          }
        },
      );
      final response = await http.put(url, body: body);
      // final responseData = json.decode(response.body);
    } catch (error) {
      log('something went wrong auth file , function userInfo');
      log(error.toString());
    }
  }

  Future<Map> getUserInfo() async {
    try {
      String api = await Apikey().userInfo;
      final url = Uri.parse(api.toString());
      log('url $url');
      http.Response response = await http.get(url);

      Map responseData = await json.decode(response.body) as Map;
      log('auth file function getUserInfo responseData ${responseData.toString()}');
      log('auth file function getUserInfo response ${response.toString()}');
      // if (responseData == null) {
      //   log('\n\n nulllllllllllllllllll\n\n');
      //   //  return throw Error();
      //   return throw HttpException('This is not a restaurant account');
      // }
      await LocalStorage().saveAuthUserInfoInLocalStorage(responseData);

      return responseData;
    } catch (error) {
      log('auth file function getUserInfo \nError: $error');
    }
    print('shit');
    return {};
  }

  Future<void> updateUserInfo(String userName, String phoneNumber) async {
    try {
      String api = await Apikey().userInfo;

      final url = Uri.parse(api.toString());
      var body = json.encode(
        {
          "userName": userName,
          // "email": email,
          "phoneNumber": phoneNumber,
        },
      );
      final response = await http.patch(url, body: body);
      Map info = await getUserInfo();
      await LocalStorage().saveAuthUserInfoInLocalStorage(info);
    } catch (error) {
      log(error.toString());
      log('something went wrong auth file , function updateUserInfo');
    }
  }

  Future<void> forgotPassword(String email) async {
    //? Send password reset email
    email = email.trim();
    try {
      // log("forgot password key ${Apikey().forgotPassword.toString()}");
      final url = Uri.parse(Apikey().forgotPassword.toString());
      log('url $url');
      http.Response response = await http.post(
        url,
        body: json.encode({
          "email": email,
          "requestType": "PASSWORD_RESET",
        }),
      );
    } catch (error) {
      log('Error-> auth file, function forgotPassword \nError: $error');
    }
  }

  static Future<Map> authInfo() async {
    // final prefs = await SharedPreferences.getInstance();
    // if (!prefs.containsKey(Auth.authUserData)) return {};
    // final data = prefs.get(Auth.authUserData).toString();
    // final dataInfo = json.decode(data);
    // log(" userInfo ${dataInfo['token']}");
    final dataInfo = LocalStorage().userInfo;
    return dataInfo;
  }
}
