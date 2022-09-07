import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'http/API/apiKey.dart';
import 'http/firebaseStorage.dart';

class Restaurant {
  // ignore: slash_for_doc_comments
  /**
  *? info
  *? void = - and get = + setAndGet =
  *# Functions
  *$ - updateRestaurantInfo
  *$ = imageUrl
  *$ = workLicense
  *$ = imageProfile
  *$ = address
  *$ = type
  *$ = categories 
  *$ = 
  *$ + 
  *$ + 
  *$ + 
  */
  String? _restaurantName;
  File? _workLicense;
  File? _commercialRegistry;
  File? _imageProfile;
  String? _address;
  String? _type;
  Restaurant();

  String? get address => _address;

  String? get type => _type;

  String? get restaurantName => _restaurantName;

  File? get workLicense => _workLicense;

  File? get imageProfile => _imageProfile;

  File? get commercialRegistry => _commercialRegistry;

  void setAddress(String address) {
    _address = address;
  }

  void setType(String type) {
    _type = type;
  }

  void setRestaurantName(String restaurantName) {
    _restaurantName = restaurantName;
  }

  void setWorkLicense(File workLicense) {
    _workLicense = workLicense;
  }

  void setImageProfile(File imageProfile) {
    _imageProfile = imageProfile;
  }

  void setCommercialRegistry(File commercialRegistry) {
    _commercialRegistry = commercialRegistry;
  }

  Future<void> updateRestaurantInfo() async {
    try {
      String api = await Apikey().userInfo;
      final url = Uri.parse(api.toString());
      var body = json.encode(
        {
          "isCompleteInfo": "true",
          "restaurantInfo": {
            "name": restaurantName,
            "address": address,
            "type": type,
          }
        },
      );
      await http.patch(url, body: body);
      FirebaseStorage().uploadImage(commercialRegistry!, "commercialRegistry");
      FirebaseStorage().uploadImage(workLicense!, "workLicense");
    } catch (error) {
      log('something went wrong Restaurant file , function updateRestaurantInfo');
      log(error.toString());
    }
  }
}
