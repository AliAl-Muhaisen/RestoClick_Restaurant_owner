import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/localStorage.dart';
import '../../models/verify.dart';
import '../../models/http/http_exception.dart';
import '../../models/user.dart';
import '../../themes/stander/buttons.dart';
import '../../translations/locale_keys.dart';
import '../../widgets/inputFormField.dart';
import '../../widgets/loadingSpin.dart';
import '../../widgets/utils/addSpace.dart';
import '../../widgets/utils/showDialog.dart';
import '../models/provider/auth.dart';
import '../widgets/account/accountWidget.dart';

class EditAccount extends StatefulWidget {
  static const routeName = '/EditAccount';
  const EditAccount({Key? key}) : super(key: key);

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  @override
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _passwordController = TextEditingController();
  InputFormField? email;
  User user = User();
  InputFormField? phoneNumber;
  InputFormField? OwnerName;

  late Future<Map> getUserInfo;

  @override
  void initState() {
    super.initState();
    email = InputFormField(
      label: LocaleKeys.inputForm_email_label.tr(),
      inputIcon: Icons.email_outlined,
      keyBoardType: TextInputType.emailAddress,
      hintText: LocaleKeys.inputForm_email_hintText.tr(),
      validator: (value) => Verify().isEMail(value),
      onSaved: (String value) => user.setEmail(value),
      // isEnable: false,
      initialValue: 'ali@gmail.com',
    );
    phoneNumber = InputFormField(
      inputIcon: Icons.phone,
      keyBoardType: TextInputType.phone,
      label: LocaleKeys.inputForm_phoneNumber_label.tr(),
      hintText: null,
      initialValue: '0781992596',
      validator: (value) => Verify().isPhoneNumber(value),
      onSaved: (String value) => user.setPhoneNumber(value),
    );
    OwnerName = InputFormField(
      inputIcon: Icons.account_circle,
      keyBoardType: TextInputType.name,
      label: LocaleKeys.inputForm_userName_label.tr(),
      initialValue: 'Ali',
      hintText: LocaleKeys.inputForm_userName_hintText.tr(),
      validator: (value) => Verify().isUserName(value),
      onSaved: (String value) => user.setName(value),
    );
    // getUserInfo = User.userInfo();
    getUserInfo = LocalStorage().userInfo;
    // TODO: implement initState
  }

  // Future<void> _submit() async {
  //   if (!_formKey.currentState!.validate()) {
  //     log('invalid inputs');
  //     //! Invalid inputs
  //     return;
  //   }

  //   _formKey.currentState!.save();

  //   setState(() {
  //     _isLoading = true;
  //   });
  //   try {
  //     await Provider.of<Auth>(context, listen: false)
  //         .updateUserInfo(user.name, user.phoneNumber);
  //     showHttpDialog(
  //       LocaleKeys.showHttpDialog_titleAndMessage_success_update_title.tr(),
  //       LocaleKeys.showHttpDialog_titleAndMessage_success_update_message.tr(),
  //       LocaleKeys.showHttpDialog_buttonText_success.tr(),
  //       context,
  //     );
  //   } on HttpException catch (error) {
  //     var errorMessage = 'Authentication failed';
  //     if (error.toString().contains('EMAIL_EXISTS')) {
  //       errorMessage = 'This email address is already in use.';
  //     } else if (error.toString().contains('INVALID_EMAIL')) {
  //       errorMessage = 'This is not a valid email address';
  //     } else if (error.toString().contains('WEAK_PASSWORD')) {
  //       errorMessage = 'This password is too weak.';
  //     }
  //     // showHttpDialog(errorMessage, context);
  //   } catch (error) {
  //     //! Error
  //     log('error');
  //     log(error.toString());

  //     showHttpDialog(
  //       LocaleKeys.showHttpDialog_titleAndMessage_error_clientError_title.tr(),
  //       LocaleKeys.showHttpDialog_titleAndMessage_error_clientError_message
  //           .tr(),
  //       LocaleKeys.showHttpDialog_buttonText_error.tr(),
  //       context,
  //     );
  //   }

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getUserInfo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Map data = snapshot.data as Map;

                // // log('future builder data ${data['email']}');
                // OwnerName!.initialValue = data['userName'];
                // phoneNumber!.initialValue = data['phoneNumber'];
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfilePic(),
                      AddVerticalSpace(15),
                      OwnerName!,
                      phoneNumber!,
                      email!,
                      const ForgotPasswordButton(),
                      AddVerticalSpace(15),
                      if (_isLoading)
                        spinKitLoading()
                      else
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(LocaleKeys.settingPage_submit.tr()),
                            style: loginSignButtonStyle(
                              radius: 20,
                              backColor: Color.fromARGB(218, 255, 255, 255),
                              frontColor: Colors.black87,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  ],
                );
              }
              return spinKitLoading();
            },
          ),
        ),
      ),
    );
  }
}
