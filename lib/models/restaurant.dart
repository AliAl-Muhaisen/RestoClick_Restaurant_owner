import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'http/API/apiKey.dart';

class Restaurant {
  String? _restaurantName;
  File? _workLicense;
  File? _commercialRegistry;
  String? _address;
  Restaurant();

  String? get address => _address;

  String? get restaurantName => _restaurantName;

  File? get workLicense => _workLicense;

  File? get commercialRegistry => _commercialRegistry;

  void setAddress(String address) {
    _address = address;
  }

  void setRestaurantName(String restaurantName) {
    _restaurantName = restaurantName;
  }

  void setWorkLicense(File workLicense) {
    _workLicense = workLicense;
  }

  void setCommercialRegistry(File commercialRegistry) {
    _commercialRegistry = commercialRegistry;
  }

  Future<void> updateRestaurantInfo(String restaurantName, String address) async {
    try {
    String api = await Apikey().userInfo;
    final url = Uri.parse(api.toString());
    var body = json.encode(
      {
        "restaurantInfo": {
          // "isActive": "true",
          "name": restaurantName,
          "address": address,
        }
      },
    );
    final response = await http.patch(url, body: body);
    }
    catch (error) {
      log('something went wrong Restaurant file , function updateRestaurantInfo');
      log(error.toString());
    }
  }
}
