import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {

  // ignore: slash_for_doc_comments
  /** 
  *? info
  *? void = - and get = +
  *# Functions
  *$ -saveAuthUserDataInLocalStorage
  *$ -removeLocalStorage
  *$ -saveAuthUserInfoInLocalStorage
  *$ + authData
  *$ + _getAuthData
  *$ + userInfo
  *$ + _getUserInfo
  *$ + userName
  *$ + token
  *$ + phoneNumber
  *$ + email
  *$ + isCompleteInfo
  *$ + userId
  *$ + expiryDate
  */

  static final LocalStorage _localStorage = LocalStorage._internal();

  factory LocalStorage() {
    return _localStorage;
  }

  LocalStorage._internal();
  Future<void> saveAuthUserDataInLocalStorage(
    String token,
    String userId,
    DateTime expiryDate,
  ) async {
    log('local storage file');
    final prefs = await SharedPreferences.getInstance();

    final userData = json.encode(
      {
        'token': token,
        'userId': userId,
        'expiryDate': expiryDate.toIso8601String(),
      },
    );
    await prefs.setString(VarName.authData.toShortString(), userData);
    // log('authUserData saved with value : ${prefs.get(VarName.authData.toShortString()).toString()}');
  }

  Future<void> saveAuthUserInfoInLocalStorage(Map info) async {
    final prefs = await SharedPreferences.getInstance();
    log('local storage file');

    final userInfo = json.encode(
      {
        'userName': info['userName'],
        'phoneNumber': info['phoneNumber'],
        "email": info['email'],
        "isCompleteInfo": info['isCompleteInfo'],
      },
    );
    await prefs.setString(VarName.userInfo.toShortString(), userInfo);

    // log('authUserInfo saved with value : ${prefs.get(VarName.userInfo.toShortString()).toString()}');
  }

  Future<void> removeLocalStorage() async {
    log('local storage file remove');

    final prefs = await SharedPreferences.getInstance();
    // prefs.remove(authUserData);
    prefs.clear();
  }

  

  Future<Map?> get authData async {
    final prefs = await SharedPreferences.getInstance();
    try {
      if (prefs.containsKey(VarName.authData.toShortString())) {
        final extractedUserData = await json.decode(
                prefs.getString(VarName.authData.toShortString()).toString())
            as Map;
        // log(extractedUserData.toString());
        return extractedUserData;
      }
    } catch (error) {
      log('something went wrong LocalStorage authData function \n Error \n$error');
    }
    return null;
  }

  Future<String?> _getAuthData(String valueName) async {
    final extractedUserData = await authData;
    final value = await extractedUserData![valueName];
    return value.toString();
  }

  Future<Map> get userInfo async {
    final prefs = await SharedPreferences.getInstance();
    final extractedUserData = await json.decode(
        prefs.getString(VarName.userInfo.toShortString()).toString()) as Map;
    // log(extractedUserData.toString());
    return extractedUserData;
  }

  Future<String> _getUserInfo(String valueName) async {
    final extractedUserData = await userInfo;
    final value = await extractedUserData[valueName];
    return value.toString();
  }

  Future<String> get userName async {
    //? get token from local storage
    log('get userName');

    final userName = await _getUserInfo(VarName.userName.toShortString());
    return userName.toString();
  }

  Future<String> get phoneNumber async {
    //? get token from local storage
    log('get phoneNumber');

    final phoneNumber = await _getUserInfo(VarName.phoneNumber.toShortString());
    return phoneNumber.toString();
  }

  Future<String> get email async {
    //? get token from local storage
    log('get email');

    final email = await _getUserInfo(VarName.email.toShortString());
    return email.toString();
  }

  Future<String> get token async {
    //? get token from local storage
    log('get token');
    final token = await _getAuthData(VarName.token.toShortString());
    return token.toString();
  }

  Future<bool?> get isCompleteInfo async {
    //? get isCompleteInfo from local storage

    log('get isCompleteInfo value');
    final isComplete =
        await _getUserInfo(VarName.isCompleteInfo.toShortString());

    if (isComplete.toString() != null && isComplete.toString() == 'false') {
      return false;
    } else if (isComplete.toString() != null &&
        isComplete.toString() == 'true') {
      return true;
    }
    return null;
  }

  Future<String> get userId async {
    //? get userId from local storage
    log('get userId');
    // final prefs = await SharedPreferences.getInstance();
    // final extractedUserData =
    //     await json.decode(prefs.getString(authUserData).toString()) as Map;
    // final userId =
    //     await extractedUserData[VarName.userId.toShortString()] as String?;
    final userId = await _getAuthData(VarName.userId.toShortString());
    return userId.toString();
  }

  Future<String> get expiryDate async {
    //? get expiryDate from local storage

    final expiryDate = await _getAuthData(VarName.expiryDate.toShortString());
    log('get expiryDate $expiryDate');

    return expiryDate.toString();
  }
}

enum VarName {
  token,
  userId,
  expiryDate,
  email,
  userName,
  phoneNumber,
  authData,
  userInfo,
  isCompleteInfo,
}

extension ParseToString on VarName {
  String toShortString() {
    return toString().split('.').last;
  }
}
