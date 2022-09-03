import 'dart:convert';
import 'dart:developer';

import 'package:restaurant_owner_app/models/restaurant.dart';
import 'package:restaurant_owner_app/screens/auth/confirmInfo.dart';
import 'package:restaurant_owner_app/screens/restaurant/Menu.dart';
import 'package:restaurant_owner_app/screens/test.dart';

import '/models/screen.dart';
import '/models/http/auth.dart';
// import '../screens/profile/accountSettingPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  static const routeName = '/homePage';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                Provider.of<Auth>(context, listen: false).logout();
                log('logout');
              },
              child: const Text("Logout"),
            ),

            ElevatedButton(
              onPressed: () async {
                Screen().pushNamed(context, Menu.routeName);
              },
              child: const Text("Menu"),
            ),
            ElevatedButton(
              onPressed: () async {
               Restaurant restaurant=Restaurant();
              //  restaurant.updateRestaurantInfo();
              },
              child: const Text("update data"),
            ),
            ElevatedButton(
              onPressed: () {
                Screen().pushNamed(context, Test.routeName);
              },
              child: const Text('test image'),
            ),
            ElevatedButton(
              onPressed: () {
                Screen().pushNamed(context, ConfirmInfoPage.routeName);
              },
              child: const Text('ConfirmInfoPage'),
            ),
            ElevatedButton(
              onPressed: () {
                log('Setting');
              },
              child: const Text("Setting"),
            ),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final extractedUserData = await json.decode(
                    prefs.getString(Auth.authUserInfo).toString()) as Map;

                final data = await Provider.of<Auth>(context, listen: false)
                    .getUserInfo();
                //  final s=await Provider.of<Auth>(context, listen: false).saveAauthUserInfoInLocalStorage(data);
                log('Data nigga22222222222222222 $data \n user name: ${data['userName']}');
                log('Data nigga $extractedUserData \n user name: ');

                // log(extractedUserData.toString());
              },
              child: const Text("Fetch data"),
            ),
          ],
        ),
      ),
    );
  }
}
