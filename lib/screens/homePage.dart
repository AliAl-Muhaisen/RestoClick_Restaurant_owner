import 'dart:convert';
import 'dart:developer';

import 'package:restaurant_owner_app/models/http/firebaseStorage.dart';
import 'package:restaurant_owner_app/models/localStorage.dart';
import 'package:restaurant_owner_app/models/restaurant.dart';
import 'package:restaurant_owner_app/models/provider/restaurant/restaurantMenu.dart';
import 'package:restaurant_owner_app/screens/auth/confirmInfo.dart';
import 'package:restaurant_owner_app/screens/restaurant/addMealPage.dart';
import 'package:restaurant_owner_app/screens/splashPage.dart';
import 'package:restaurant_owner_app/screens/test.dart';
import 'package:restaurant_owner_app/widgets/utils/floatingNavbar.dart';

import '/models/screen.dart';
import '../models/provider/auth.dart';
// import '../screens/profile/accountSettingPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homePage';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: FloatingNavbar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                Screen().pushNamed(context, SplashPage.routeName);
              },
              child: const Text("splash"),
            ),
            ElevatedButton(
              onPressed: () async {
                Provider.of<Auth>(context, listen: false).logout();
                log('logout');
              },
              child: const Text("Logout"),
            ),
            ElevatedButton(
              onPressed: () async {
                final extractedUserData = await LocalStorage().userInfo;
                final data = await Provider.of<Auth>(context, listen: false)
                    .getUserInfo();
                log('User Data  $data \n user name: ${data['userName']}');
                log('\nuser info  $extractedUserData \n ');
              },
              child: const Text("Fetch user data"),
            ),
          ],
        ),
      ),
    );
  }
}
