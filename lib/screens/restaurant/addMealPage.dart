// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:restaurant_owner_app/widgets/utils/addSpace.dart';
import 'package:restaurant_owner_app/widgets/utils/showDialog.dart';

import '../../models/provider/restaurant/category.dart';
import '../../models/provider/restaurant/meal.dart';
import '../../models/screen.dart';
import '../../models/verify.dart';
import '../../widgets/account/accountWidget.dart';
import '../../widgets/inputFormField.dart';
import '../../widgets/loadingSpin.dart';
import '../../widgets/utils/dropDownListForm.dart';
import '../../widgets/utils/floatingNavbar.dart';

class MealPage extends StatefulWidget {
  static const routeName = '/MenuMeal';
  final Meal? oldMeal;
  const MealPage({Key? key, this.oldMeal}) : super(key: key);

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  InputFormField? mealTitle;
  InputFormField? mealPrice;
  Meal meal = Meal();
  bool isOldMeal = false;
  File? mealImage;
  CardSetting? mealImageCard;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    isOldMeal = widget.oldMeal == null ? false : true;
    if (isOldMeal) {
      log(widget.oldMeal!.categories.toString());
      meal.setCategories(widget.oldMeal!.categories);
    }
    mealPrice = InputFormField(
      inputIcon: Icons.money_off,
      keyBoardType: TextInputType.number,
      label: 'Price',
      hintText: null,
      enabledBorderRadius: 12,
      focusedBorderRadius: 12,
      validator: (value) => Verify().isPrice(price: value),
      onSaved: (String value) => meal.setPrice(value),
      initialValue: isOldMeal ? widget.oldMeal!.price : "",
    );
    mealTitle = InputFormField(
      inputIcon: Icons.restaurant_menu,
      keyBoardType: TextInputType.name,
      label: 'Meal Title',
      hintText: '',
      enabledBorderRadius: 12,
      focusedBorderRadius: 12,
      validator: (value) => Verify().isRestaurantName(value),
      onSaved: (String value) => meal.setTitle(value),
      initialValue: isOldMeal ? widget.oldMeal?.title : "",
    );

    mealImageCard = CardSetting(
      tailIcon: Icons.upload_rounded,
      icon: Icons.image_search_rounded,
      onPressed: () async {
        final myFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (myFile == null) return;
        setState(() {
          meal.setImageFile(File(myFile.path));
        });
      },
      text: 'Upload Meal image',
    );
    // TODO: implement initState
    super.initState();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() ||
        (meal.imageFile == null && !isOldMeal)) {
      log('invalid inputs');
      //! Invalid!
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (isOldMeal) {
        if (meal.categories.isEmpty) {
          log("NULLLLLLLLLLLLLLLL");
        }
        log(meal.categories);
        meal.setId(widget.oldMeal!.id);
        await meal.update();
      } else {
        await meal.uploadToDataBase();
      }

      // Screen().pop(context);

      showHttpDialog(
          'great job',
          'Your meal has been ${isOldMeal ? "updated" : "added"} to the menu correctly',
          'okay',
          context);
      // Screen().pushReplacementNamed(context, FloatingNavbar.routeName);
    } catch (error) {
      log('error');
      log(error.toString());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add meal")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AddVerticalSpace(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    child: mealTitle!,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    child: mealPrice!,
                  ),
                  DropDownListForm(
                    title: isOldMeal
                        ? widget.oldMeal!.categories
                        : "Select meal's type",
                    errorMessage: isOldMeal ? "" : "Please select meal's type",
                    useValidation: isOldMeal ? false : true,
                    listItem: Category().mealCategories,
                    onSave: (String value) => meal.setCategories(value),
                  ),
                  CardMealMenu(
                    onPressed: (value) {
                      meal.setIsGlutenFree(value);
                    },
                    text: 'Gluten Free',
                    toggle: isOldMeal ? widget.oldMeal!.isGlutenFree! : false,
                  ),
                  mealImageCard!,
                  if (meal.imageFile == null &&
                      widget.oldMeal?.imageUrl == null)
                    const Text('no image selected')
                  else
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: isOldMeal
                          ? (meal.imageFile == null
                              ? Image.network(
                                  widget.oldMeal!.imageUrl,
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  meal.imageFile!,
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.cover,
                                ))
                          : Image.file(
                              meal.imageFile!,
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                    ),
                  AddVerticalSpace(20),
                  if (_isLoading)
                    spinKitLoading()
                  else
                    SizedBox(
                      width: 330,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: Text(isOldMeal ? "Update" : "Add"),
                      ),
                    ),
                  AddVerticalSpace(100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
