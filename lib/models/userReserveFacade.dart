import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:restaurant_owner_app/models/feedback.dart';
import 'package:restaurant_owner_app/models/user.dart';

import 'reservation.dart';
import 'http/API/apiKey.dart';

class UserReserveFacade {
  Reservation? reserve;
  final User user;
  final String id;
  Feedback? feedback;
  static List<UserReserveFacade> _feedbackWithUserList = [];
  static List<UserReserveFacade> _reportWithUserList = [];
  UserReserveFacade({
    required this.id,
    required this.reserve,
    required this.user,
  });

  UserReserveFacade.feedback({
    required this.user,
    required this.id,
    required this.feedback,
  });

  static Future<List<UserReserveFacade>> get reserveWithUser async {
    Map<String, dynamic>? reserveDataKeys = {};
    Map<String, dynamic>? userData = {};
    List<UserReserveFacade> reservesWithUser = [];
    List<String> reserveKeys = [];

    try {
      String api = await Apikey().getRestaurantReservations();
      Uri url = Uri.parse(api.toString());

      //# Fetch data from the server
      http.Response response = await http.get(url);

      reserveDataKeys = await json.decode(response.body);
      if (reserveDataKeys?.isEmpty ?? true) return [];
      //# To convert json data to list of reserves
      reserveDataKeys!.forEach((key, value) => reserveKeys.add(key));

      for (int i = 0; i < reserveKeys.length; i++) {
        Reservation? reserve =
            await Reservation.getReservedById(reserveKeys[i]);
        if (reserve != null) {
          api = await Apikey().getUser(userId: reserve.userId!);
          url = Uri.parse(api.toString());
          response = await http.get(url);
          userData = await json.decode(response.body);
          User user = User.fromJsonWithCustom(userData!);

          UserReserveFacade result =
              UserReserveFacade(reserve: reserve, user: user, id: reserve.id!);
          reservesWithUser.add(result);
        }
      }
      return reservesWithUser;
    } catch (e) {
      //! Connection error or NULL response

      return [];
    }
  }

  static Future<List<UserReserveFacade>?> reportWithUser({
    bool isRefresh = false,
  }) async {
    try {
      if (_reportWithUserList.isNotEmpty && !isRefresh) {
        return _reportWithUserList;
      }
      _reportWithUserList = await _getFeedbackWithUser(isReport: true) ?? [];
      return _reportWithUserList;
    } catch (e) {
      return [];
    }
  }

  static Future<List<UserReserveFacade>?> feedbackWithUser({
    bool isRefresh = false,
  }) async {
    try {
      if (_feedbackWithUserList.isNotEmpty && !isRefresh) {
        return _feedbackWithUserList;
      }
      _feedbackWithUserList = await _getFeedbackWithUser() ?? [];
      return _feedbackWithUserList;
    } catch (e) {
      return [];
    }
  }

  static Future<List<UserReserveFacade>?> _getFeedbackWithUser(
      {bool isReport = false}) async {
    try {
      List<Feedback> feedbacks;
      if (isReport) {
        feedbacks = await Feedback().restaurantReports ?? [];
      } else {
        feedbacks = await Feedback().restaurantFeedbacks ?? [];
      }
      String api;
      Uri uri;
      http.Response response;
      Map<String, dynamic>? userData;
      List<UserReserveFacade> feedbackWithUser = [];

      for (var i = 0; i < feedbacks.length; i++) {
        api = await Apikey().getUser(userId: feedbacks[i].userId!);
        uri = Uri.parse(api.toString());
        response = await http.get(uri);
        userData = await json.decode(response.body);
        User user = User.fromJsonWithCustom(userData!);

        UserReserveFacade result = UserReserveFacade.feedback(
          user: user,
          id: feedbacks[i].id!,
          feedback: feedbacks[i],
        );
        feedbackWithUser.add(result);
      }
      return feedbackWithUser;
    } catch (e) {
      return [];
    }
  }
}
