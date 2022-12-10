import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_owner_app/models/http/firebaseStorage.dart';
import '../../http/API/apiKey.dart';
import 'package:http/http.dart' as http;

class Meal with ChangeNotifier {
  // ignore: slash_for_doc_comments
  /**
  *? info
  *? void = - and get = + setAndGet =
  *# Functions
  *$ - uploadToDataBase
  *$ - deleteMeal
  *$ = imageUrl
  *$ = title
  *$ = price
  *$ = isGlutenFree
  *$ = isVegetarian
  *$ = categories 
  *$ = 
  *$ + 
  *$ + 
  *$ + 
  */
  String? _id; //! just for build constructor only
  String? _imageUrl; //! just for build constructor only
  String? _title;
  File? _imageFile;
  String? _price;
  // final List<String> categories;
  bool _isGlutenFree = false;
  bool _isVegetarian = false;
  String? _categories;
  // default constructor
  Meal();
  //constructor
  Meal.build(
      {required title,
      required imageUrl,
      required isGlutenFree,
      required isVegetarian,
      required categories,
      required id}) {
    _id = id;
    _imageUrl = imageUrl;
    setTitle(title);
    setCategories(categories);
    setIsGlutenFree(isGlutenFree);
    setIsVegetarian(isVegetarian);
  }
  //constructor
  Meal.fromJson(Map<String, dynamic> mealData, String? mealId)
      : _title = mealData['title'] ?? '',
        _imageUrl = mealData['imageUrl'] ?? '',
        _isGlutenFree = mealData['isGlutenFree'] ?? false,
        _isVegetarian = mealData['isVegetarian'] ?? false,
        _categories = mealData['categories'] ?? '',
        _price = mealData['price'] ?? 0,
        _id = mealId ?? '';

  String get imageUrl => _imageUrl!; //! just for build constructor only
  String get id => _id!; //! just for build constructor only

  String get categories {
    return _categories!;
  }

  /// You should use this method if you want to update the product
  void setId(String id) {
    _id = id;
  }

  /// You should use this method if you want to update the product
  void setImageUrl(String imageUrl) {
    _imageUrl = imageUrl;
  }

  void setCategories(String categoriesList) {
    _categories = categoriesList;
  }

  void setTitle(String title) {
    _title = title;
  }

  void setImageFile(File imageFile) {
    _imageFile = imageFile;
  }

  void setIsGlutenFree(bool isGlutenFree) {
    _isGlutenFree = isGlutenFree;
  }

  void setIsVegetarian(bool isVegetarian) {
    _isVegetarian = isVegetarian;
  }

  void toggleIsGlutenFree() {
    _isGlutenFree = !_isGlutenFree;
  }

  void toggleIsVegetarian() {
    _isVegetarian = !_isVegetarian;
  }

  void setPrice(String price) {
    _price = price;
  }

  String? get title {
    return _title;
  }

  File? get imageFile {
    return _imageFile;
  }

  bool? get isGlutenFree {
    return _isGlutenFree;
  }

  bool? get isVegetarian {
    return _isVegetarian;
  }

  String? get price {
    return _price;
  }

  Future<void> uploadToDataBase() async {
    try {
      String api = await Apikey().menu;
      Uri url = Uri.parse(api.toString());
      http.Response response = await http.post(
        url,
        body: json.encode({
          "title": title,
          "isGlutenFree": isGlutenFree,
          "isVegetarian": isVegetarian,
          "categories": categories,
          "price": price
        }),
      );
      Map responseData = json.decode(response.body);

      log(responseData['name'].toString());
      String mealId = responseData['name'];

      //?save image in firebase storage then take the url for that image and put it in the database
      String imageUrl =
          await FirebaseStorage().uploadImageMenuMeal(imageFile!, mealId);
      api = await Apikey().updateAndDeleteMenuMeal(mealId);
      url = Uri.parse(api.toString());
      response = await http.patch(
        url,
        body: json.encode({"imageUrl": imageUrl}),
      );
      log('The meal has been successfully added to the menu');
    } catch (error) {
      log('something went wrong RestaurantMenu file , function uploadToDataBase \nError');
      log(error.toString());
    }
  }

  Future<void> update() async {
    try {
      String api = await Apikey().updateAndDeleteMenuMeal(id);
      Uri url = Uri.parse(api.toString());
      String newImageUrl = imageUrl;
      if (imageFile?.path.toString().isNotEmpty ?? false) {
        log("file is not empty");
        try {
          await FirebaseStorage().deleteMealImage(id);
          newImageUrl =
              await FirebaseStorage().uploadImageMenuMeal(imageFile!, id);
          setImageUrl(newImageUrl);
        } catch (e) {
          //! Error
          log("Failed to update the image of meal models-> provider-> meal-> update function");
          log("Error: " + e.toString());
        }
      }

      http.Response response = await http.patch(
        url,
        body: json.encode({
          "title": title!,
          "isGlutenFree": isGlutenFree!,
          "isVegetarian": isVegetarian!,
          "categories": categories,
          "price": price!,
          "imageUrl": imageUrl,
        }),
      );
      log(response.toString());
    } catch (e) {
      log('something went wrong RestaurantMenu file , update function \nError');
      log(e.toString());
    }
  }

  Future<void> deleteMeal(String mealId) async {
    try {
      String api = await Apikey().updateAndDeleteMenuMeal(mealId);
      Uri url = Uri.parse(api.toString());
      await http.delete(url);
      await FirebaseStorage().deleteMealImage(mealId);
      log('The meal has been deleted successfully');
      notifyListeners();
    } catch (error) {
      log('something went wrong RestaurantMenu file , function deleteMeal \nError');
      log(error.toString());
    }
  }
}
