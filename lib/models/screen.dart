import '/screens/homePage.dart';
import '/screens/mainPage.dart';
// import '/screens/profile/accountSettingPage.dart';
// import '/screens/profile/editAccount.dart';
import '/screens/signupPage.dart';
import '/screens/splashPage.dart';
import 'package:flutter/material.dart';

import '../screens/loginPage.dart';

class Screen {
  static final Screen _screen = Screen._internal();
  factory Screen() {
    return _screen;
  }
  Screen._internal();

  Map<String, Widget Function(BuildContext)> routes = {
    MainPage.routeName: (context) => MainPage(),
    LoginPage.routeName: (context) => LoginPage(),
    SignUpPage.routeName: (context) => SignUpPage(),
    HomePage.routeName: (context) => HomePage(),
    SplashPage.routeName: (context) => SplashPage(),
    // AccountSettingPage.routeName: (context) => AccountSettingPage(),
    // EditAccount.routeName: (context) => EditAccount()
  };

  void pushNamed(BuildContext context, page) {
    print('push with name');
    Navigator.of(context).pushNamed(page);
  }

  void pushReplacementNamed(BuildContext context, page) {
    print('push with ReplacementNamed');
    Navigator.of(context).pushReplacementNamed(page);
  }

  void pop(
    BuildContext context,
  ) {
    Navigator.of(context).pop();
  }

  void navigatorPush(BuildContext context, page) {
    print('singleton');
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
