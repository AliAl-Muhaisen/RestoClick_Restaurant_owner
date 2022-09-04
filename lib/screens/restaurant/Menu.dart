import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_owner_app/widgets/utils/addSpace.dart';
import '../../models/restaurant/restaurantMenu.dart';
import '../../models/screen.dart';
import '../../models/verify.dart';
import '../../widgets/account/accountWidget.dart';
import '../../widgets/inputFormField.dart';

class Menu extends StatefulWidget {
  static const routeName = '/Menu';
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  InputFormField? mealTitle;
  Meal meal = Meal();
  File? mealImage;
  CardSetting? mealImageCard;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    mealTitle = InputFormField(
      inputIcon: Icons.restaurant_menu,
      keyBoardType: TextInputType.name,
      label: 'Meal Title',
      hintText: '',
      validator: (value) => Verify().isRestaurantName(value),
      onSaved: (String value) => meal.setTitle(value),
    );
    mealImageCard = CardSetting(
      tailIcon: Icons.upload_rounded,
      icon: Icons.image_search_rounded,
      onPressed: () async {
        final myFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (myFile == null) return;
        setState(() {
          // mealImage = File(myFile.path);
          meal.setImageFile(File(myFile.path));
        });
      },
      text: 'Upload Meal image',
    );
    // TODO: implement initState
    super.initState();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || meal.imageFile == null) {
      print('invalid inputs');
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      print('try');
      meal.uploadToDataBase();
      Screen().pop(context);
    } catch (error) {
      print('error');
      print(error);
      // showHttpDialog(
      //   LocaleKeys.showHttpDialog_titleAndMessage_error_clientError_title.tr(),
      //   LocaleKeys.showHttpDialog_titleAndMessage_error_clientError_message
      //       .tr(),
      //   LocaleKeys.showHttpDialog_buttonText_error.tr(),
      //   context,
      // );
    }
    setState(() {
      _isLoading = false;
    });
  }

  bool wifi = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add meal")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              // textDirection: TextDirection.,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AddVerticalSpace(20),
                mealTitle!,
                CardMealMenu(
                  onPressed: (value) {
                    meal.setIsGlutenFree(value);
                  },
                  text: 'Gluten Free',
                ),
                CardMealMenu(
                  onPressed: (value) {
                    meal.setIsVegetarian(value);
                  },
                  text: 'Vegetarian',
                ),
                mealImageCard!,
                if (meal.imageFile == null)
                  const Text('no image selected')
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      meal.imageFile!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                AddVerticalSpace(20),
                SizedBox(
                  width: 330,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text("continue"),
                  ),
                ),
                AddVerticalSpace(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
