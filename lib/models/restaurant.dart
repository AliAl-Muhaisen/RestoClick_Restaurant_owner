import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'http/API/apiKey.dart';
import 'http/firebaseStorage.dart';
import 'provider/restaurant/meal.dart';

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

  String? _id;
  String? _imageProfileUrl;
  Restaurant.fromJson(
      Map<String, dynamic> restaurantData, String? restaurantId) {
    final resInfo = restaurantData["restaurantInfo"] as Map;
    _imageProfileUrl = restaurantData['imageUrl'];
    _address = resInfo['address'];
    _restaurantName = resInfo['name'];
    _type = resInfo['type'];
    _id = restaurantId;
  }

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

  /// To get restaurant ID
  String get id => _id!;

  /// To get restaurant imageProfileUrl
  String get imageProfileUrl => _imageProfileUrl!;

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

  /// To get restaurants from database
  static Future<List<Restaurant>> getRestaurants() async {
    List<Restaurant> restaurants = [];

    final api = await Apikey().restaurants;
    final url = Uri.parse(api.toString());
    try {
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {}
      final data = await json.decode(response.body);
      data.forEach((key, value) {
        Restaurant newRes = Restaurant.fromJson(value, key);
        restaurants.add(newRes);
      });
    } catch (error) {
      log("something went wrong models->restaurant->getRestaurants");
      log(error.toString());
    }

    return restaurants;
  }

   /// To get the restaurant menu
  Future<List<Meal>?> get menu async {
    Map<String, dynamic> menuData = {};
    List<Meal> menu = [];
    try {
      final api = await Apikey().getMenuResCompetitor(id); //# Restaurant ID
      final url = Uri.parse(api.toString());

      //# Fetch data from the server
      http.Response response = await http.get(url);

      menuData = await json.decode(response.body);

      //# To convert json data to list of meals
      menuData.forEach((key, value) => menu.add(Meal.fromJson(value, key)));
    } catch (error) {
      //! Connection error or NULL response
      log("something went wrong models-> restaurants file-> get menu");
      log(error.toString());
      return [];
    }

    return menu;
  }

}
