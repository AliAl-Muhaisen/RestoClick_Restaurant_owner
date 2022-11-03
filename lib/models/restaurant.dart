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
  */
  /// Class Variables
  String? _restaurantName;
  File? _workLicense;
  File? _commercialRegistry;
  File? _imageProfile;
  String? _address;
  String? _type;
  Restaurant();

  /// To get restaurant address
  String? get address => _address;

  /// To get restaurant type
  String? get type => _type;

  /// To get restaurant name
  String? get restaurantName => _restaurantName;

  /// To get restaurant workLicense
  File? get workLicense => _workLicense;

  /// To get restaurant imageProfile
  File? get imageProfile => _imageProfile;

  /// To get restaurant commercialRegistry
  File? get commercialRegistry => _commercialRegistry;

  /// Set restaurant address
  void setAddress(String address) {
    _address = address;
  }

  /// Set restaurant type
  ///   -Restaurant
  ///   -Farm
  ///   -Coffee House
  void setType(String type) {
    _type = type;
  }

  /// Set restaurant name
  void setRestaurantName(String restaurantName) {
    _restaurantName = restaurantName;
  }

  /// Set restaurant workLicense
  void setWorkLicense(File workLicense) {
    _workLicense = workLicense;
  }

  /// Set restaurant Image Profile
  void setImageProfile(File imageProfile) {
    _imageProfile = imageProfile;
  }

  /// Set restaurant Commercial Registry
  void setCommercialRegistry(File commercialRegistry) {
    _commercialRegistry = commercialRegistry;
  }

  Future<void> updateRestaurantInfo() async {
    try {
      String api = await Apikey().userInfo;
      final url = Uri.parse(api.toString());
      await FirebaseStorage()
          .uploadImage(imageProfile!, "restaurantProfileImage");
      String urlRestaurantImage = await FirebaseStorage()
          .getRestaurantRegistrationImageUrl("restaurantProfileImage");
      await FirebaseStorage()
          .uploadImage(commercialRegistry!, "commercialRegistry");
      await FirebaseStorage().uploadImage(workLicense!, "workLicense");

      String workLicenseImageUrl = await FirebaseStorage()
          .getRestaurantRegistrationImageUrl("workLicense");
      String commercialRegistryImageUrl = await FirebaseStorage()
          .getRestaurantRegistrationImageUrl("commercialRegistry");

      var body = json.encode(
        {
          "imageUrl": urlRestaurantImage,
          "isCompleteInfo": "true",
          "restaurantInfo": {
            "name": restaurantName,
            "address": address,
            "type": type,
            "workLicenseImageUrl": workLicenseImageUrl,
            "commercialRegistryImageUrl": commercialRegistryImageUrl
          }
        },
      );

      await http.patch(url, body: body);
    } catch (error) {
      log('something went wrong Restaurant file , function updateRestaurantInfo');
      log(error.toString());
    }
  }
}
