import 'dart:async';
import 'dart:convert';
import 'dart:developer';
//
import 'package:flutter/material.dart';
import '../localStorage.dart';

import '../http/API/apiKey.dart';
import '../http/http_exception.dart';
import '../user.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  ///## Auth, login, Signup and logout

  /// Functions

  ///*!-------
  ///** get token
  /// * * get userId
  ///*!-------
  ///* * _authenticate   //?@param String email, String password,String apiKey,
  ///**  login   //?@param String email, String password
  ///** signup //?@param User user
  ///** tryAutoLogin
  ///**  _autoLogout
  ///**  logout
  ///**  setUserInfo //?@param String phoneNumber, String userName
  ///** getUserInfo
  ///** updateUserInfo(String userName, String phoneNumber)
  /// *# updateUserInfo(String userName, String phoneNumber)
  /// *!--------
  ///

  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  bool _isCompleteInfo = false;
  bool get isCompleteInfo {
    return _isCompleteInfo;
  }

  /// To check if the user is authenticated
  bool get isAuth {
    return (token != null);
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
    String apiKey, {
    bool isLogin = false,
  }) async {
    final url = Uri.parse(apiKey);
    email = email.toLowerCase();
    try {
      // log('url $url');
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
      Map responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      // log('responseData $responseData');
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

      await LocalStorage().saveAuthUserDataInLocalStorage(
        token!,
        userId!,
        _expiryDate!,
      );
      if (isLogin) {
        await _waitToCreateUserRecord();
      }
    } catch (error) {
      log('Error auth file authenticate function $error');
      rethrow;
    }
  }

  Future<void> _waitToCreateUserRecord() async {
    Map info = await getUserInfo();
    await LocalStorage().saveAuthUserInfoInLocalStorage(info);
    if (info.isEmpty) {
      log('not a restaurant account');
      _token = null;
      throw Error();
    } else if (!info.containsKey('restaurantInfo')) {
      log('Complete restaurant information');
    } else {
      log('All done');
      _isCompleteInfo = true;
    }
    notifyListeners();
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    final url = Uri.parse(Apikey().login);
    await _authenticate(
      email,
      password,
      (Apikey().login),
      isLogin: true,
    );
  }

  Future<void> signup(
    User user,
  ) async {
    await _authenticate(user.email, user.password, (Apikey().signup));
    await setUserInfo(user.name, user.phoneNumber, user.email);
    await _waitToCreateUserRecord();
    // Screen().pushReplacementNamed(context, ConfirmInfoPage.routeName);
  }

  Future<bool> tryAutoLogin() async {
    log('trying to login ');

    //? Attempt to auto-login
    DateTime expiryDate;
    try {
      expiryDate = DateTime.parse(await LocalStorage().expiryDate);
      if (expiryDate.isBefore(DateTime.now())) {
        // ! Auto login failed
        log('Auto login failed');
        return false;
      }
    } catch (e) {
      return false;
    }

    _token = await LocalStorage().token;
    _userId = await LocalStorage().userId;
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
          "isActive": "false",
          "isCompleteInfo": "false",
        },
      );
      await http.put(url, body: body);
    } catch (error) {
      log('something went wrong auth file , function userInfo');
      log(error.toString());
    }
  }

  Future<Map> getUserInfo() async {
    try {
      String api = await Apikey().userInfo;
      final url = Uri.parse(api.toString());
      // log('url $url');
      http.Response response = await http.get(url);

      Map responseData = await json.decode(response.body) as Map;
      // log('auth file function getUserInfo responseData ${responseData.toString()}');
      // log('auth file function getUserInfo response ${response.toString()}');

      await LocalStorage().saveAuthUserInfoInLocalStorage(responseData);
      notifyListeners();
      return responseData;
    } catch (error) {
      log('auth file function getUserInfo \nError: $error');
    }
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
      await http.patch(url, body: body);
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
      final url = Uri.parse(Apikey().forgotPassword.toString());
      // log('url $url');
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
    final dataInfo = LocalStorage().userInfo;
    return dataInfo;
  }
}
