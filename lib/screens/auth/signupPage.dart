import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/screen.dart';
import '../../models/user.dart';
import '../../models/verify.dart';
import '../../models/provider/auth.dart';
import '../../models/http/http_exception.dart';
import '../../themes/stander/buttons.dart';
import '../../translations/locale_keys.dart';
import '../../widgets/inputFormField.dart';
import '../../widgets/loadingSpin.dart';
import '../../widgets/utils/addSpace.dart';
import '../../widgets/utils/showDialog.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = '/SignupPage';
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  User user = User();
  InputFormField? email;
  InputFormField? password;
  InputFormField? phoneNumber;
  InputFormField? restaurantOwnerName;

  @override
  void initState() {
    email = InputFormField(
      label: LocaleKeys.inputForm_email_label.tr(),
      inputIcon: Icons.email_outlined,
      keyBoardType: TextInputType.emailAddress,
      hintText: LocaleKeys.inputForm_email_hintText.tr(),
      validator: (value) => Verify().isEMail(value),
      onSaved: (String value) => user.setEmail(value),
    );

    password = InputFormField(
      label: LocaleKeys.inputForm_password_label.tr(),
      inputIcon: Icons.shield,
      keyBoardType: TextInputType.visiblePassword,
      hintText: null,
      validator: (value) => Verify().isPassword(value),
      onSaved: (String value) => user.setPassword(value),
      obscureText: true,
    );

    phoneNumber = InputFormField(
      inputIcon: Icons.phone,
      keyBoardType: TextInputType.phone,
      label: LocaleKeys.inputForm_phoneNumber_label.tr(),
      hintText: null,
      validator: (value) => Verify().isPhoneNumber(value),
      onSaved: (String value) => user.setPhoneNumber(value),
    );
    restaurantOwnerName = InputFormField(
      inputIcon: Icons.account_circle,
      keyBoardType: TextInputType.name,
      label: LocaleKeys.inputForm_userName_label.tr(),
      hintText: LocaleKeys.inputForm_userName_hintText.tr(),
      validator: (value) => Verify().isUserName(value),
      onSaved: (String value) => user.setName(value),
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _submit() async {
    log('submitted form');

    if (!_formKey.currentState!.validate()) {
      log('invalid inputs');
      //! Invalid!
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });
    try {

      await Provider.of<Auth>(context, listen: false).signup(user);
      Screen().pop(context);
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      }
      showHttpDialog("Error",errorMessage,"Okay",context);
    } catch (error) {
      log('signup error');
      log(error.toString());
      showHttpDialog(
        LocaleKeys.showHttpDialog_titleAndMessage_error_clientError_title.tr(),
        LocaleKeys.showHttpDialog_titleAndMessage_error_clientError_message
            .tr(),
        LocaleKeys.showHttpDialog_buttonText_error.tr(),
        context,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                restaurantOwnerName!,
                email!,
                phoneNumber!,
                password!,
                AddVerticalSpace(15),
                if (_isLoading)
                   spinKitLoading()
                else
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 30,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: Text(LocaleKeys.signup.tr()),
                      style: loginSignButtonStyle(radius: 20),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
