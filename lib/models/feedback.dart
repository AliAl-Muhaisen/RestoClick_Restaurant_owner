import 'dart:convert';

import 'http/API/apiKey.dart';
import 'localStorage.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;

class Feedback {
  /// Class Variables

  String? _id;
  String? _text;
  double? _rate;
  String? _userId;

  bool _isUserReported = false;

  /// Default constructor
  Feedback();

  Feedback.build({
    required String id,
    required String text,
    required double rate,
  }) {
    setId(id);
    setText(text);
    setRate(rate);
  }

  Feedback.fromJSON(Map<String, dynamic> values, String id)
      : _id = id,
        _text = values['comment'] ?? '',
        _rate = values['rate'].toDouble() ?? 0,
        _userId = values['userId'];

  ///getters
  String? get id => _id;
  String? get userId => _userId;
  String? get text => _text;
  double? get rate => _rate;
  bool get isUserReported => _isUserReported;

  ///setters
  void setId(String id) => _id = id;
  void setText(String text) => _text = text;
  void setRate(double rate) => _rate = rate;

  void setIsUserReported(bool isUserReported) =>
      _isUserReported = isUserReported;

  Future<List<Feedback>?> get restaurantFeedbacks async {
    try {
      List<Feedback> result = await _getRestaurantFeedbacks() ?? [];

      return result;
    } catch (e) {
      return [];
    }
  }

  Future<List<Feedback>?> get restaurantReports async {
    try {
      List<Feedback> result =
          await _getRestaurantFeedbacks(isReport: true) ?? [];

      return result;
    } catch (e) {
      return [];
    }
  }

//#heeeeeeeeeere
  Future<List<Feedback>?> _getRestaurantFeedbacks(
      {bool isReport = false}) async {
    Map<String, dynamic>? feedbackDataKeys;
    List<String> feedbackIds = [];
    try {
      List<Feedback> result = [];
      List<String> reportsIds = await restaurantFeedbackIds(isReport: isReport);

      String api = await Apikey().getFeedbackRestaurant(isReport: isReport);
      Uri uri = Uri.parse(api.toString());
      http.Response response = await http.get(uri);
      feedbackDataKeys =
          await json.decode(response.body) as Map<String, dynamic>?;
      if (feedbackDataKeys?.isEmpty ?? true) return [];
      feedbackDataKeys!.forEach((key, value) => feedbackIds.add(key));

      for (var i = 0; i < feedbackIds.length; i++) {
        Feedback? feedback = await feedbackById(id: feedbackIds[i]);
        if (feedback != null) {
          if (reportsIds.isNotEmpty &&
              reportsIds.contains('${feedback.userId}$feedbackIds[i]')) {
            feedback.setIsUserReported(true);
          }

          result.add(feedback);
        }
      }
      return result;
    } catch (e) {
      log("restaurantFeedbacks $e");
      return [];
    }
  }

  static Future<List<String>> restaurantFeedbackIds({
    bool isReport = false,
  }) async {
    Map<String, dynamic>? feedbackDataKeys;
    List<String> feedbackIds = [];
    try {
      String api = await Apikey().getFeedbackRestaurant(isReport: isReport);
      Uri uri = Uri.parse(api.toString());
      http.Response response = await http.get(uri);
      feedbackDataKeys =
          await json.decode(response.body) as Map<String, String>?;
      if (feedbackDataKeys?.isEmpty ?? true) return [];
      feedbackDataKeys!.forEach((key, value) => feedbackIds.add(key));
      return feedbackIds;
    } catch (e) {
      return [];
    }
  }

  Future<Feedback?> feedbackById({required String id}) async {
    Map<String, dynamic>? data;
    try {
      String api = await Apikey().getFeedback(feedbackId: id);
      Uri uri = Uri.parse(api.toString());
      http.Response response = await http.get(uri);
      data = await json.decode(response.body) as Map<String, dynamic>?;
      if (data?.isEmpty ?? true) return null;
      Feedback feedback = Feedback.fromJSON(data!, id);
      return feedback;
    } catch (e) {
      return null;
    }
  }

  static Future<void> reportUser({
    required String reportText,
    required String userId,
    required String id,
  }) async {
    try {
      String createReportId = "$id$userId";
      String api = await Apikey().getFeedbackRestaurant(isReport: true);
      Uri uri = Uri.parse(api.toString());
      await http.patch(uri, body: json.encode({createReportId: userId}));
      api = await Apikey().getFeedback();
      uri = Uri.parse(api.toString());
      await http.patch(uri,
          body: json.encode({
            createReportId: {"text": reportText}
          }));
    } catch (e) {}
  }

  /*
  static Future<bool> getIsUserReportBefore(
      {required String reservationId}) async {
    String api = await Apikey().getFeedbackUser(isReport: true);
    bool result = false;
    Uri uri = Uri.parse(api.toString());
    try {
      http.Response response = await http.get(
        uri,
      );

      Map? body = await json.decode(response.body) as Map;
      if (body.isEmpty) return false;
      body.forEach((key, value) {
        if (value == reservationId) {
          result = true;
        }
      });

      return result;
    } catch (e) {
      return false;
    }
  }
   */
}
