import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import './http/API/apiKey.dart';

class Category {
  List<String> category = [
    "Family",
    "Friends",
    "Couples",
    "Birth Day",
  ];

  Future<List<String>> get selectedCategory async {
    Map<String, dynamic>? categoryData = {};
    List<String> categories = [];
    try {
      String api = await Apikey().getCategory();
      Uri url = Uri.parse(api.toString());
      http.Response response = await http.get(url);

      categoryData = await json.decode(response.body);
      if (categoryData?.isEmpty ?? true) return [];
      categoryData as Map<String, dynamic>;
      categoryData.forEach((key, value) {
        categories.add(key);
      });
      // for(int i=0;i<)
    } catch (e) {
      log("something went wrong models-> category file-> get selectedCategory");
      log(e.toString());
    }
    return categories;
  }

  Future<void> addItem(String newCategory) async {
    try {
      String api = await Apikey().getCategory();
      Uri url = Uri.parse(api.toString());
      var body = json.encode({newCategory: true});
      await http.patch (url, body: body);
    } catch (e) {
      log("something went wrong models-> category file-> addItem");
      log(e.toString());
    }
  }

  Future<void> addItems(List<String> newCategories) async {
    try {
      Map<String, bool> body = {};
      String api = await Apikey().getCategory();
      Uri url = Uri.parse(api.toString());

      for (int i = 0; i < newCategories.length; i++) {
        body[newCategories[i]] = true;
        // await addItem(newCategories[i]);
      }
      log(json.encode(body));
      await http.put(url, body: json.encode(body));
    } catch (e) {
      log("something went wrong models-> category file-> addItems");
      log(e.toString());
    }
  }

  Future<void> delete(String category) async {
    try {
      String api = await Apikey().getCategory(category: category);
      Uri url = Uri.parse(api.toString());
      await http.delete(url);
    } catch (e) {
      log("something went wrong models-> delete file-> addItems");
      log(e.toString());
    }
  }
}
