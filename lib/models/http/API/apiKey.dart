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

  /// To get the restaurant's competitors
  Future<String> get restaurants async {
    final token = await LocalStorage().token;
    String url = getAPIbyKey('DataBase').toString() +
        "restaurantUsers.json?auth=" +
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

  Future<String> getMenuResCompetitor(String restaurantId) async {
    /// To get [menu] information and [meals] from the database

    final token = await LocalStorage().token;
    String url = getAPIbyKey('DataBase').toString() +
        "restaurantMenu/$restaurantId.json?auth=" +
        token.toString();
    return url.toString();
  }

  Future<String> reservation({String? reservedId}) async {
    /// To get [reserve] information from the database

    final token = await LocalStorage().token;
    String url = getAPIbyKey('DataBase').toString() +
        "reservations${(reservedId?.isNotEmpty ?? false) ? "/$reservedId" : ''}.json?auth=" +
        token.toString();
    return url.toString();
  }

  Future<String> getRestaurantReservations({String? reservedId}) async {
    final token = await LocalStorage().token;
    final userId = await LocalStorage().userId;

    String url = getAPIbyKey('DataBase').toString() +
        "restaurantUsers/$userId/reservationsId${(reservedId?.isNotEmpty ?? false) ? "/$reservedId" : ''}.json?auth=" +
        token.toString();

    return url.toString();
  }

  Future<String> getUserReservation({
    String? reservedId,
    required String userId,
  }) async {
    final token = await LocalStorage().token;
    String url = getAPIbyKey('DataBase').toString() +
        "users/${userId.toString()}${reservedId?.isNotEmpty ?? false ? "/reservationsId/$reservedId" : ''}.json?auth=" +
        token.toString();

    return url.toString();
  }

  Future<String> getCategory({
    String? category,
  }) async {
    final token = await LocalStorage().token;
    final userId = await LocalStorage().userId;

    String url = getAPIbyKey('DataBase').toString() +
        "restaurantCategory/${userId.toString()}${category?.isNotEmpty ?? false ? "/$category" : ''}.json?auth=" +
        token.toString();

    return url.toString();
  }
}
