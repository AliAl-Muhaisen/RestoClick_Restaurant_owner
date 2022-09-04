import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:restaurant_owner_app/models/http/auth.dart';
import 'package:restaurant_owner_app/models/localStorage.dart';
import 'package:restaurant_owner_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseStorage {
  static final FirebaseStorage _fireStorage = FirebaseStorage._internal();
  factory FirebaseStorage() {
    return _fireStorage;
  }

  FirebaseStorage._internal();

  Future<void> uploadImage(File file, String fileName) async {
    String userId = await LocalStorage().userId;
    String directory =
        "${FileDirectory.restaurantRegistration.toShortString()}/$userId";
    if (userId == null) {
      throw Error();
    }
    await _uploadImage(file, directory, fileName);
  }
Future<void> uploadImageMenuMeal(File file, String fileName) async {
    String userId = await LocalStorage().userId;
    String directory =
        "${FileDirectory.restaurantMenu.toShortString()}/$userId";
    if (userId == null) {
      throw Error();
    }
    await _uploadImage(file, directory, fileName);
  }
  Future<void> _uploadImage(
      File file, String directory, String fileName) async {
    log('------------------- *-* -_- ^-^ ^_^ <-_-> ');

    file = createFile(file);
    if (file == null) return;
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    String imageName = file.path.split('/').last;
    try {
      await storage.ref('$directory/$fileName').putFile(file);
    } catch (error) {
      log('something went wrong FirebaseStorage file , uploadImage function \nError:');
      log(error.toString());
    }
  }

  File createFile(File file) {
    return File(file.path);
  }
}

enum FileDirectory {
  restaurantRegistration,
  userProfileImage,
  restaurantMenu,
}

extension ParseToString on FileDirectory {
  String toShortString() {
    return toString().split('.').last;
  }
}
