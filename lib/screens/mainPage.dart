import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../models/screen.dart';
import '../themes/stander/buttons.dart';
import '../themes/stander/text.dart';
import '../translations/locale_keys.dart';
import '../widgets/languageDropDown.dart';
import 'loginPage.dart';
import 'signupPage.dart';

class MainPage extends StatelessWidget {
  // const MainPage({Key? key}) : super(key: key);
  static const String routeName = '/mainPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          LanguageDropButton(context),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                LocaleKeys.appName.tr(),
                style: appNameTextStyle,
              ),
            ),
            Text(
              LocaleKeys.appName_Description.tr(),
              style: describeAppNameTextStyle,
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.only(top: 35, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonloginAndSign(LocaleKeys.login.tr(), () {
                    Screen().pushNamed(context, LoginPage.routeName);
                  }),
                  ButtonloginAndSign(LocaleKeys.signup.tr(), () {
                    Screen().pushNamed(context, SignUpPage.routeName);
                  }),
                ],
              ),
            ),
            
            
          ],
        ),
      ),
    );
  }
}

Widget ButtonloginAndSign(String text, Function onPressed) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: SizedBox(
      width: 130,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: Text(text),
        style: loginSignButtonStyle(),
      ),
    ),
  );
}
