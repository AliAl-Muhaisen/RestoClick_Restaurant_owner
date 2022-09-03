import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:restaurant_owner_app/models/http/auth.dart';
import 'package:restaurant_owner_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseStorage {
  static final FirebaseStorage _fireStorage = FirebaseStorage._internal();
  factory FirebaseStorage() {
    return _fireStorage;
  }

  FirebaseStorage._internal();

  Future<void> uploadImage(File file,String fileName) async {
    log('------------------- *-* -_- ^-^ ^_^ <-_-> ');

    file = createFile(file);
    if (file == null) return;
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    String imageName = file.path.split('/').last;
    try {
       Map userData =await Auth.authInfo();

      if (userData == {}) {
       throw Error();
      }
      await storage
          .ref('${FileDirectory.restaurantRegistration.toShortString()}/${userData['userId']}/$fileName')
          .putFile(file);
     
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
}

extension ParseToString on FileDirectory {
  String toShortString() {
    return toString().split('.').last;
  }
}
