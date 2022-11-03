import 'dart:convert';
import 'dart:developer';

import 'localStorage.dart';

class User {
  ///*? info
  ///*? void = - and get = + setAndGet =
  ///*# Functions
  ///*$ -
  /// *$ = email
  /// *$ = password
  ///*$ = name
  ///*$ = imageProfile
  ///*$ = phoneNumber
  ///*$ + userInfo

  /// Class Variables
  String? _email;
  String? _password;
  String? _name;
  String? _phoneNumber;
  String? _imageProfile;

  User();

  User.fromJsonWithCustom(
    Map<String, dynamic> json,
  ) {
    _name = json['name'];
    _email = json['email'];
    _password = json['password'];
  }

  /// To set user Email
  void setEmail(String email) {
    _email = email;
  }

  /// To set user Password
  void setPassword(String password) {
    _password = password;
  }

  /// To set user Name
  void setName(String name) {
    _name = name;
  }

  /// To set user PhoneNumber
  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
  }

  /// To set user Image Profile
  void setImageProfile(String imageProfile) {
    _imageProfile = imageProfile;
  }

  /// To get user name
  String get name {
    return _name!;
  }

  /// To get user email
  String get email {
    return _email!;
  }

  /// To get user password
  String get password {
    return _password!;
  }

  /// To get user imageProfile
  String get imageProfile {
    return _imageProfile!;
  }

  /// To get user phoneNumber
  String get phoneNumber {
    return _phoneNumber!;
  }

  static Future<Map> userInfo() async {
    // final prefs = await SharedPreferences.getInstance();
    // final data=prefs.get(Auth.authUserInfo).toString();
    final dataInfo = await LocalStorage().userInfo;
    log(" userInfo ${dataInfo['userName']}");
    return dataInfo;
  }
}
