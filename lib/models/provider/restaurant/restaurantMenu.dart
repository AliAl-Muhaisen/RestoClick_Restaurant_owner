import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'meal.dart';
import '../../http/API/apiKey.dart';
import 'package:http/http.dart' as http;

class RestaurantMenu with ChangeNotifier {
  // ignore: slash_for_doc_comments
  /**
  *? info
  *? void = - and get = + setAndGet =
  *# Functions
  *$ = 
  *$ + menu
  *$ + restaurantMenu
  *$ + 
  */
  List<Meal> _mealList = [];

  Future<Map> get menu async {
    Map<String, dynamic> menuData = {};
    try {
      String api = await Apikey().menu;
      final url = Uri.parse(api.toString());
      http.Response response = await http.get(url);
      menuData = await json.decode(response.body);
    } catch (error) {
      log('something went wrong RestaurantMenu file , function uploadToDataBase');
      log(error.toString());
    }

    List<Meal> saveData = [];
    menuData.forEach((k, v) => saveData.add(Meal.fromJson(v, k)));
    _mealList = saveData;

    notifyListeners();
    restaurantMenu;
    return menuData;
  }

  List<Meal> get restaurantMenu {
    return [..._mealList];
  }
}

class Category {
  // ignore: slash_for_doc_comments
  /**
  *? info
  *? void = - and get = + setAndGet =
  *# Functions
  *$ + mealCategories
  *$ + _categories
  *$ + restaurantMenu
  *$ + restaurantCategories
  */
  static final Category _category = Category._internal();
  factory Category() {
    return _category;
  }

  Category._internal();

  final List<String> _restaurantCategories = [
    'Arabic Food'
        'Italian',
    'Hamburgers',
    'German',
    'Breakfast',
    'Asian',
    'French',
    'SeaFood',
  ];
  final List<String> _mealCategories = [
    'Arabic Food'
        'Italian',
    'Hamburgers',
    'German',
    'Breakfast',
    'Asian',
    'French',
    'SeaFood',
  ];
  List<String> get restaurantCategories {
    return [..._restaurantCategories];
  }

  List<String> get mealCategories {
    return [..._mealCategories];
  }
}
