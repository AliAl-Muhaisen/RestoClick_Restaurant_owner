import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import './http/API/apiKey.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'localStorage.dart';

class Reservation {
  String? _id;

  int? _numOfPeople;
  DateTime? _date;

  String? _hour;

  String? _userId;
  String? _restaurantId;
  String? _status;

  Reservation();

  int get numOfPeople => _numOfPeople!;

  DateTime get date => _date!;

  String? get hour => _hour;

  String? get id => _id;

  String? get userId => _userId;
  String? get restaurantId => _restaurantId;
  String? get status => _status;

  void setUserId(String userId) => _userId = userId;
  void setRestaurantId(String restaurantId) => _restaurantId = restaurantId;
  void setStatus(String status) => _status = status;

  void setId(String id) => _id = id;

  void setNumOfPeople(int value) {
    _numOfPeople = value;
  }

  void setDate(DateTime date) {
    _date = date;
  }

  void setHour(String hour) {
    _hour = hour;
  }

  String get dateAsString {
    return date.toString().split(" ")[0];
  }

  Reservation.fromJson(Map<String, dynamic> reserveData, String? reserveId)
      : _id = reserveId ?? '',
        _hour = reserveData['hour'],
        _date = DateTime.parse(reserveData['date']),
        _status = reserveData['status'] ?? 'waiting',
        _numOfPeople = reserveData['numOfPeople'] ?? 1,
        _restaurantId = reserveData['restaurantId'] ?? '',
        _userId = reserveData['userId'] ?? '';

  static Future<Reservation?> getReservedById(String reservedId) async {
    Map<String, dynamic>? reserveData = {};

    try {
      String api = await Apikey().reservation(reservedId: reservedId);
      Uri url = Uri.parse(api.toString());
      http.Response response = await http.get(url);
      reserveData = await json.decode(response.body) as Map<String, dynamic>;

      Reservation reserve = Reservation.fromJson(reserveData, reservedId);

      return reserve;
    } catch (e) {
      log("something went wrong models-> reserve file-> get getReservedById");
      log(e.toString());
      return null;
    }
  }

  static Future<List<Reservation>> get restaurantReservations async {
    Map<String, dynamic>? reserveDataKeys = {};
    List<Reservation> reserves = [];
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
        Reservation? reserve = await getReservedById(reserveKeys[i]);
        if (reserve != null) {
          reserves.add(reserve);
        }
      }
      return reserves;
    } catch (e) {
      //! Connection error or NULL response
      log("something went wrong models-> reserve file-> get userReservations");
      log(e.toString());
      return [];
    }
  }

  Future<void> delete() async {
    try {
      String api = await Apikey().reservation(reservedId: id);
      Uri url = Uri.parse(api.toString());
      await http.delete(url);

      api = await Apikey().getUserReservation(reservedId: id!, userId: userId!);
      url = Uri.parse(api.toString());
      await http.delete(url);

      api = await Apikey().getRestaurantReservations(reservedId: id!);
      url = Uri.parse(api.toString());
      await http.delete(url);
    } catch (e) {
      log("something went wrong models-> reserve file-> get delete");
      log(e.toString());
    }
  }

  Future<void> updateStatus({required String status}) async {
    try {
      setStatus(status);
      String api = await Apikey().reservation(reservedId: id);
      Uri url = Uri.parse(api.toString());
      http.patch(
        url,
        body: json.encode({
          "status": status,
        }),
      );
    } catch (e) {
      log("something went wrong models-> reserve file-> get update");
      log(e.toString());
    }
  }
}
