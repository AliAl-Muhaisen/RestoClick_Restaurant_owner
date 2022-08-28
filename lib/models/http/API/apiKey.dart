import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth.dart';

class Apikey with ChangeNotifier {
  static final Apikey _apikey = Apikey._internal();

  factory Apikey() {
    return _apikey;
  }

  Apikey._internal();

  String get _apiKey {
    return dotenv.get('API_KEY').toString();
  }

  String getAPIbyKey(String key) {
    return dotenv.get(key).toString();
  }

  String get signup {
    return '${getAPIbyKey('API_Signup')}$_apiKey';
  }

  String get login {
    return '${getAPIbyKey('Login_EndPoint')}$_apiKey';
  }

  Future<String> get userInfo async {
    final prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        await json.decode(prefs.getString(Auth.authUserData).toString()) as Map;
    final token = await extractedUserData['token'] as String?;
    final userId = await extractedUserData['userId'] as String?;
    String url = getAPIbyKey('DataBase').toString() +
        "restaurantUsers/$userId.json?auth=" +
        token.toString();
    // log('\n\n\n get userInfo333 $url\n\n\n');
    return url.toString();
  }
}
