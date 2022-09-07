import 'dart:convert';
import 'dart:developer';

import 'localStorage.dart';

class User {
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

  void setEmail(String email) {
    _email = email;
  }

  void setPassword(String password) {
    _password = password;
  }

  void setName(String name) {
    _name = name;
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
  }

  void setImageProfile(String imageProfile) {
    _imageProfile = imageProfile;
  }

  String get name {
    return _name!;
  }

  String get email {
    return _email!;
  }

  String get password {
    return _password!;
  }

  String get imageProfile {
    return _imageProfile!;
  }

  String get phoneNumber {
    return _phoneNumber!;
  }
  static Future<Map>  userInfo() async{
    // final prefs = await SharedPreferences.getInstance();
    // final data=prefs.get(Auth.authUserInfo).toString();
   final dataInfo= await LocalStorage().userInfo;
    log(" userInfo ${dataInfo['userName']}");
    return dataInfo;
  }
}
