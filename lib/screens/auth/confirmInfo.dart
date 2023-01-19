import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/provider/restaurant/category.dart';
import '../../models/restaurant.dart';
import '../../widgets/loadingSpin.dart';
import '../../widgets/utils/addSpace.dart';

import '../../models/provider/auth.dart';
import '../../models/verify.dart';
import '../../widgets/account/accountWidget.dart';
import '../../widgets/inputFormField.dart';
import '../../widgets/utils/dropDownListForm.dart';

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
  // File? workLicense;
  // File? commercialRegistry;
  CardSetting? commercialRegistryCard;
  CardSetting? workLicenseCard;
  CardSetting? imageProfile;
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
      enabledBorderRadius: 12,
      focusedBorderRadius: 12,
      validator: (value) => Verify().isUserName(value),
      onSaved: (String value) => restaurant.setRestaurantName(value),
    );

    address = InputFormField(
      inputIcon: Icons.location_on,
      keyBoardType: TextInputType.name,
      label: 'Address',
      enabledBorderRadius: 12,
      focusedBorderRadius: 12,
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
          restaurant.setCommercialRegistry(File(myFile.path));
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
          restaurant.setWorkLicense(File(myFile.path));
        });
      },
      text: 'Upload Work License image',
    );

    imageProfile = CardSetting(
      tailIcon: Icons.upload_rounded,
      icon: Icons.image_search_rounded,
      onPressed: () async {
        final myFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (myFile == null) return;
        setState(() {
          restaurant.setImageProfile(File(myFile.path));
        });
      },
      text: 'Upload restaurant profile image',
    );

    // TODO: implement initState
    super.initState();
  }

  Future<void> _submit() async {
    log('submitted form');
    if (!_formKey.currentState!.validate() ||
        restaurant.commercialRegistry == null ||
        restaurant.workLicense == null ||
        restaurant.imageProfile == null) {
      log('invalid inputs');
      // Invalid!
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isLoading = true;
      });
      await restaurant.updateRestaurantInfo();
      await Provider.of<Auth>(context, listen: false).getUserInfo();

      log('All done <*_->');
    } catch (error) {
      log('something went wrong ConfirmInfoPage file , submit function \nError:');
      log(error.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Info"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  restaurantName!,
                  address!,
                  DropDownListForm(
                    title: "restaurant type",
                    onSave: (String value) => restaurant.setType(value),
                    listItem: Category().restaurantCategories,
                    errorMessage: "please select restaurant's type",
                    buttonColor: Colors.white,
                    paddingButtonHorizontal: 10,
                  ),
                  imageProfile!,
                  imageText(restaurant.imageProfile),
                  commercialRegistryCard!,
                  imageText(restaurant.commercialRegistry),
                  workLicenseCard!,
                  imageText(restaurant.workLicense),
                  AddVerticalSpace(10),
                  if (_isLoading)
                    spinKitLoading()
                  else
                    SizedBox(
                      width: 330,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: const Text("continue"),
                      ),
                    ),
                  AddVerticalSpace(20),
                  if (!_isLoading)
                    ElevatedButton(
                      onPressed: () async {
                        Provider.of<Auth>(context, listen: false).logout();
                        log('logout');
                      },
                      child: const Text("Logout"),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
