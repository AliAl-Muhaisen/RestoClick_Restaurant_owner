import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_owner_app/models/http/firebaseStorage.dart';
import 'package:restaurant_owner_app/models/restaurant.dart';

import '../../models/verify.dart';
import '../../widgets/account/accountWidget.dart';
import '../../widgets/inputFormField.dart';

class ConfirmInfoPage extends StatefulWidget {
  static const routeName = '/confirmInfoPage';
  const ConfirmInfoPage({Key? key}) : super(key: key);

  @override
  State<ConfirmInfoPage> createState() => _ConfirmInfoPageState();
}

class _ConfirmInfoPageState extends State<ConfirmInfoPage> {
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  InputFormField? restaurantName;
  InputFormField? address;
  File? workLicense;
  File? commercialRegistry;
  CardSetting? commercialRegistryCard;
  CardSetting? workLicenseCard;
  Restaurant restaurant = Restaurant();

  Text imageText(File? file) {
    if (file == null) {
      return const Text(
        "no image selected",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 238, 61, 58),
        ),
      );
    }

    return Text(
      file.path.split('/').last,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  void initState() {
    restaurantName = InputFormField(
      inputIcon: Icons.restaurant,
      keyBoardType: TextInputType.name,
      label: 'Restaurant Name',
      hintText: '',
      validator: (value) => Verify().isUserName(value),
      onSaved: (String value) => restaurant.setRestaurantName(value),
    );

    address = InputFormField(
      inputIcon: Icons.location_on,
      keyBoardType: TextInputType.name,
      label: 'Address',
      hintText: 'Amman',
      validator: (value) => Verify().isAddress(value),
      onSaved: (String value) => restaurant.setAddress(value),
    );

    commercialRegistryCard = CardSetting(
      tailIcon: Icons.upload_rounded,
      icon: Icons.image_search_rounded,
      onPressed: () async {
        final myFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (myFile == null) return;
        setState(() {
          commercialRegistry = File(myFile.path);
        });
      },
      text: 'Upload Commercial Registry image',
    );

    workLicenseCard = CardSetting(
      tailIcon: Icons.upload_rounded,
      icon: Icons.image_search_rounded,
      onPressed: () async {
        final myFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (myFile == null) return;
        setState(() {
          workLicense = File(myFile.path);
        });
      },
      text: 'Upload Work License image',
    );
    // TODO: implement initState
    super.initState();
  }

  Future<void> _submit() async {
    log('submitted form');
    if (!_formKey.currentState!.validate() ||
        commercialRegistry == null ||
        workLicense == null) {
      log('invalid inputs');
      // Invalid!
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });
    try {
      FirebaseStorage().uploadImage(commercialRegistry!, "commercialRegistry");
      FirebaseStorage().uploadImage(workLicense!, "workLicense");

      restaurant.updateRestaurantInfo(
        restaurant.restaurantName!,
        restaurant.address!,
      );

      log('All done <*_->');
    } catch (error) {
      log('something went wrong ConfirmInfoPage file , submit function \nError:');
      log(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("title")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            restaurantName!,
            address!,
            commercialRegistryCard!,
            imageText(commercialRegistry),
            workLicenseCard!,
            imageText(workLicense),
            SizedBox(
              width: 330,
              height: 50,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text("continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
