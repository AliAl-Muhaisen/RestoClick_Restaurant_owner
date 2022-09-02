// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  File file;
  Function(File) saveFile;
  UploadImage({
    Key? key,
    required this.file,
    required this.saveFile,
  }) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  Future<void> imagePicker() async {
    final myFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (myFile == null) return;
    setState(() {
      widget.file = File(myFile.path);
    });
    widget.saveFile(widget.file);
    log(widget.file.path.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: const Text("Upload"),
        onPressed: imagePicker,
      ),
    );
  }
}
