import '../screens/EditAccount.dart';
import '../screens/auth/confirmInfo.dart';
import '../screens/restaurant/competitorRestaurantDetail.dart';
import '../screens/restaurant/menuPage.dart';
import '../screens/restaurant/addMealPage.dart';
import 'package:restaurant_owner_app/screens/test.dart';

import '../screens/restaurant/myReservationPage.dart';
import '../widgets/utils/floatingNavbar.dart';
import '/screens/homePage.dart';
import '/screens/mainPage.dart';

import '../screens/auth/signupPage.dart';
import '/screens/splashPage.dart';
import 'package:flutter/material.dart';

import '../screens/auth/loginPage.dart';

class Screen {
  ///*? info
  ///*? void = - and get = + setAndGet =
  ///*# Functions
  ///*$ - pushNamed
  /// *$ - pushReplacementNamed
  ///*$ - pop
  ///*$ - navigatorPush

  static final Screen _screen = Screen._internal();

  /// To handle and manage screen changes
  factory Screen() {
    return _screen;
  }
  Screen._internal();

  Map<String, Widget Function(BuildContext)> routes = {
    MainPage.routeName: (context) => MainPage(),
    LoginPage.routeName: (context) => const LoginPage(),
    SignUpPage.routeName: (context) => const SignUpPage(),
    HomePage.routeName: (context) => const HomePage(),
    SplashPage.routeName: (context) => SplashPage(),
    Test.routeName: (context) => const Test(),
    ConfirmInfoPage.routeName: (context) => const ConfirmInfoPage(),
    MealPage.routeName: (context) => const MealPage(),
    MenuPage.routeName: (context) => MenuPage(),
    FloatingNavbar.routeName: (context) => const FloatingNavbar(),
    CompetitorRestaurantDetail.routeName: (context) =>
        CompetitorRestaurantDetail(),
    MyReservationPage.routeName: (context) => MyReservationPage(),
    EditAccount.routeName: (context) => EditAccount()
    // AccountSettingPage.routeName: (context) => AccountSettingPage(),
    // EditAccount.routeName: (context) => EditAccount()
  };

  void pushNamed(BuildContext context, pageName) {
    Navigator.of(context).pushNamed(pageName);
  }

  void pushReplacementNamed(BuildContext context, page) {
    Navigator.of(context).pushReplacementNamed(page);
  }

  void pop(
    BuildContext context,
  ) {
    Navigator.of(context).pop();
  }

  void pushNamedWithData(BuildContext context, page, data) {
    print('push with name with data');

    Navigator.of(context).pushNamed(page, arguments: data);
  }

  void navigatorPush(BuildContext context, page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
