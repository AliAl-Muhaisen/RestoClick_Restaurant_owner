import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/models/localStorage.dart';

class Apikey with ChangeNotifier {
  static final Apikey _apikey = Apikey._internal();

  /// This class is responsible to manage and handle API in the application.
  /// It will help you to connect to other servers outside the application,
  ///  you can call the back-end server and cloud only through it.
  /// So it is work as a channel between the app and  the servers.
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

  String get forgotPassword {
    return '${getAPIbyKey('Forgot_Password')}$_databaseApiKey';
  }

  Future<String> get userInfo async {
    /// To get [user] information from the database
    final token = await LocalStorage().token;
    final userId = await LocalStorage().userId;
    String url = getAPIbyKey('DataBase').toString() +
        "restaurantUsers/$userId.json?auth=" +
        token.toString();
    return url.toString();
  }

  Future<String> get menu async {
    /// To get [menu] information and [meals] from the database

    final token = await LocalStorage().token;
    final userId = await LocalStorage().userId;
    String url = getAPIbyKey('DataBase').toString() +
        "restaurantMenu/$userId.json?auth=" +
        token.toString();
    return url.toString();
  }

  Future<String> updateAndDeleteMenuMeal(String mealId) async {
    /// To update or Delete [Menu] or [Meal] from the database

    final token = await LocalStorage().token;
    final userId = await LocalStorage().userId;
    String url = getAPIbyKey('DataBase').toString() +
        "restaurantMenu/$userId/$mealId.json?auth=" +
        token.toString();
    return url.toString();
  }
}
