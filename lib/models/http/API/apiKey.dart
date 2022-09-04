import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/models/localStorage.dart';


class Apikey with ChangeNotifier {
  static final Apikey _apikey = Apikey._internal();

  factory Apikey() {
    return _apikey;
  }

  Apikey._internal();

  String get _databaseApiKey {
    return dotenv.get('API_KEY').toString();
  }

  String getAPIbyKey(String key) {
    return dotenv.get(key).toString();
  }

  String get signup {
    return '${getAPIbyKey('API_Signup')}$_databaseApiKey';
  }

  String get login {
    return '${getAPIbyKey('Login_EndPoint')}$_databaseApiKey';
  }
 String get forgotPassword
  { 
    return '${getAPIbyKey('Forgot_Password')}$_databaseApiKey';
  }

  Future<String> get userInfo async {
    // final prefs = await SharedPreferences.getInstance();
    // final extractedUserData =
    //     await json.decode(prefs.getString(Auth.authUserData).toString()) as Map;
    // final token = await extractedUserData['token'] as String?;
    // final userId = await extractedUserData['userId'] as String?;
    final token=await LocalStorage().token;
    final userId=await LocalStorage().userId;
    String url = getAPIbyKey('DataBase').toString() +
        "restaurantUsers/$userId.json?auth=" +
        token.toString();
    return url.toString();
  }
  
  Future<String> get menu async {
    final token=await LocalStorage().token;
    final userId=await LocalStorage().userId;
    String url = getAPIbyKey('DataBase').toString() +
        "restaurantMenu/$userId.json?auth=" +
        token.toString();
    return url.toString();
  }
}
