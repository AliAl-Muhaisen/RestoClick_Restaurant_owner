import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../localStorage.dart';

class FirebaseStorage {
  // ignore: slash_for_doc_comments
  /**
  *? info
  *? void = - and get = +
  *# Functions
  *$ - uploadImage
  *$ - _uploadImage
  *$ - _deleteImage
  *$ - deleteMealImage
  *$ + getImageUrlMeal
  *$ + uploadImageMenuMeal
  *$ + createFile
  *$ + _getImageUrl
  *$ + getRestaurantRegistrationImageUrl
  */
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

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

  Future<String> uploadImageMenuMeal(File file, String fileName) async {
    String userId = await LocalStorage().userId;
    if (userId == null) {
      throw Error();
    }
    String directory =
        "${FileDirectory.restaurantMenu.toShortString()}/$userId";

    await _uploadImage(file, directory, fileName);
    String imageUrl = await getImageUrlMeal(fileName);
    return imageUrl;
  }

  Future<void> _uploadImage(
    File file,
    String directory,
    String fileName,
  ) async {
    log('------------------- *-* -_- ^-^ ^_^ <-_-> ');

    file = createFile(file);
    if (file == null) return;

    String imageName = file.path.split('/').last;
    try {
      final r = await storage.ref('$directory/$fileName').putFile(file);
      log('this r ${r.ref}\n\n$r');
    } catch (error) {
      log('something went wrong FirebaseStorage file , uploadImage function \nError:');
      log(error.toString());
    }
  }

  File createFile(File file) {
    return File(file.path);
  }

  Future<String> _getImageUrl(String directory, String fileName) async {
    String userId = await LocalStorage().userId;

    String imagesUrl =
        await storage.ref('$directory/$userId/$fileName').getDownloadURL();
    log('my images meal ${imagesUrl.toString()}');
    return imagesUrl;
  }

  Future<String> getRestaurantRegistrationImageUrl(String fileName) async {
    // String userId = await LocalStorage().userId;

    String imagesUrl = await _getImageUrl(
      FileDirectory.restaurantRegistration.toShortString(),
      fileName,
    );
    return imagesUrl;
  }

  Future<String> getImageUrlMeal(String fileName) async {
    String imagesUrl = await _getImageUrl(
        FileDirectory.restaurantMenu.toShortString(), fileName);
    //  storage
    //     .ref('${FileDirectory.restaurantMenu.toShortString()}/$userId/$fileName')
    //     .getDownloadURL();
    log('my images meal ${imagesUrl.toString()}');
    return imagesUrl;
  }

  Future<void> _deleteImage(
    String directory,
    String fileName,
  ) async {
    String userId = await LocalStorage().userId;
    try {
      await storage.ref('$directory/$userId/$fileName').delete();
    } catch (error) {
      log('something went wrong firebaseStorage file deleteMealImage function');
    }
  }

  Future<void> deleteMealImage(
    String fileName,
  ) async {
    await _deleteImage(
      FileDirectory.restaurantMenu.toShortString(),
      fileName,
    );
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
