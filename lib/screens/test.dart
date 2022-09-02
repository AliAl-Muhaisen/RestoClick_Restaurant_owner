import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_owner_app/models/restaurant.dart';
import '../models/http/firebaseStorage.dart';
class Test extends StatefulWidget {
  static const routeName = '/test';
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  Restaurant restaurant=Restaurant();

  
  File? file;
  String? filePath;
  Future<void> imagePicker() async {
    final myFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (myFile == null) return;
    setState(() {
      file = File(myFile.path);
    });
    // log(file!.path.toString());
  }

  Future<void> imageUpload() async {
    // FirebaseStorage.uploadImage(file);
    FirebaseStorage().uploadImage(file!);
    // if (file == null) return;
    //  firebase_storage.FirebaseStorage storage=firebase_storage.FirebaseStorage.instance;
    // String imageBase = base64Encode(file!.readAsBytesSync());
    // log('image base = ${imageBase.toString()}');
    // String imageName = file!.path.split('/').last;
    // try {
    //   await storage.ref('testF/$imageName').putFile(file!);
     
    // } catch (error) {
    //   log(error.toString());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: imagePicker, child: const Text('choose')),
            ElevatedButton(onPressed: imageUpload, child: const Text('upload')),
            SizedBox(
              width: 100,
              height: 100,
              child: Center(
                child: file != null
                    ? Image.file(file!)
                    : const Text("no Image selected"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
