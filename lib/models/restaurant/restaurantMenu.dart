import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:restaurant_owner_app/models/http/firebaseStorage.dart';

import '../http/API/apiKey.dart';
import 'package:http/http.dart' as http;

class RestaurantMenu {
  List<Meal>? _mealList;
}

class Meal {
  String? _title;
  File? _imageFile;
  // final List<String> categories;
  bool _isGlutenFree = false;
  bool _isVegetarian = false;
  Meal();

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

  Future<void> uploadToDataBase() async {
    try {
      String api = await Apikey().menu;
      final url = Uri.parse(api.toString());
      http.Response response = await http.post(
        url,
        body: json.encode({
          "title": title,
          "isGlutenFree": isGlutenFree,
          "isVegetarian": isVegetarian,
        }),
      );
      Map responseData = json.decode(response.body);

      log(responseData['name'].toString());
      String fileName = responseData['name'];
      FirebaseStorage().uploadImageMenuMeal(imageFile!, fileName);
    } catch (error) {
      log('something went wrong RestaurantMenu file , function uploadToDataBase');
      log(error.toString());
    }
  }
}
// class Category {
//   // static int countId = 1;
//   // final int id = countId++;
//   final String id;
//   final String title;
//   final Color color;

//   const Category({
//     required this.title,
//     required this.id,
//     this.color = Colors.orange,
//   });
// }
