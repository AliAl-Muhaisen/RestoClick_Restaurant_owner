import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_owner_app/models/http/http_exception.dart';
import '../../models/provider/auth.dart';
import '../../models/screen.dart';
import '../../models/user.dart';
import '../../models/verify.dart';
import '../../themes/stander/buttons.dart';
import '../../translations/locale_keys.dart';
import '../../widgets/inputFormField.dart';
import '../../widgets/loadingSpin.dart';
import '../../widgets/utils/addSpace.dart';
import '../../widgets/utils/showDialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String routeName = '/LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  User user = User();
  InputFormField? email;
  InputFormField? password;
  @override
  void initState() {
    email = InputFormField(
      label: LocaleKeys.inputForm_email_label.tr(),
      inputIcon: Icons.email_outlined,
      keyBoardType: TextInputType.emailAddress,
      hintText: LocaleKeys.inputForm_email_hintText.tr(),
      validator: (String value) => Verify().isEMail(value),
      onSaved: (String value) => user.setEmail(value),
    );

    password = InputFormField(
      label: LocaleKeys.inputForm_password_label.tr(),
      inputIcon: Icons.shield,
      keyBoardType: TextInputType.visiblePassword,
      hintText: null,
      validator: (String value) => Verify().isUserName(value),
      onSaved: (String value) => user.setPassword(value),
    );
    super.initState();
  }
  
  @override
  void dispose(){
    super.dispose();
  }
  Future<void> _submit() async {
    log('submitted form');
    if (!_formKey.currentState!.validate()) {
      log('invalid inputs');
      // Invalid!
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .login(user.email, user.password,context);
      Screen().pop(context);

      // showHttpDialog('Account created successfully', context);
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      }
      showHttpDialog('Error', errorMessage, 'Close', context);
      // showHttpDialog(errorMessage,context);
    } catch (error) {
      log('error');
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
    // print(verify.isPassword('asld'));
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              email!,
              password!,
              const ForgotPasswordButton(),
              AddVerticalSpace(15),
              if (_isLoading)
                 spinKitLoading()
              else
                SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(LocaleKeys.login.tr()),
                    style: loginSignButtonStyle(radius: 20),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
