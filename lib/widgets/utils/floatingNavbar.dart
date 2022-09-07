import 'dart:developer';

import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_owner_app/screens/auth/confirmInfo.dart';
import 'package:restaurant_owner_app/screens/homePage.dart';
import 'package:restaurant_owner_app/themes/stander/colors.dart';
import '../../models/localStorage.dart';
import '../../screens/restaurant/menuPage.dart';

class FloatingNavbar extends StatefulWidget {
  const FloatingNavbar({Key? key}) : super(key: key);
  static const routeName = '/floatNavbar';

  @override
  State<FloatingNavbar> createState() => _FloatingNavbarState();
}

class _FloatingNavbarState extends State<FloatingNavbar> {
  // Widget build(BuildContext context) => Container(
  //       margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //       child: Container(
  //         height: 60,
  //         decoration: BoxDecoration(
  //           boxShadow: [
  //             BoxShadow(color: Colors.grey),
  //           ],
  //           color: Theme.of(context).primaryColor,
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             Icon(Icons.home_rounded),
  //             Icon(Icons.search),
  //             Icon(Icons.camera_alt),
  //             Icon(Icons.notifications),
  //             Icon(Icons.person)
  //           ],
  //         ),
  //       ),
  //     );
  Future<bool?> get isCompleteInfo async {
    return await LocalStorage().isCompleteInfo;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isCompleteInfo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          bool? data = snapshot.data as bool;
          log('future data isCompleteInfo ${snapshot.data}');

          if (!data) {
            return const ConfirmInfoPage();
          }
        }
        return FloatingNavBar(
          resizeToAvoidBottomInset: true,
          color: floatingNavbarColors,
          selectedIconColor: Color.fromARGB(255, 32, 32, 32),
          unselectedIconColor: Color.fromARGB(255, 36, 34, 34).withOpacity(0.6),
          items: [
            FloatingNavBarItem(
                iconData: Icons.home_outlined, page: HomePage(), title: 'Home'),
            FloatingNavBarItem(
                iconData: Icons.restaurant_menu_rounded,
                page: MenuPage(),
                title: 'Menu'),
            FloatingNavBarItem(
                iconData: Icons.archive_outlined,
                page: ElevatedButton(
                    child: const Text("Booking"), onPressed: () {}),
                title: 'Settings'),
            FloatingNavBarItem(
                iconData: Icons.settings,
                page: ElevatedButton(
                    child: const Text("Settings"), onPressed: () {}),
                title: 'Settings'),
          ],
          horizontalPadding: 10.0,
          hapticFeedback: true,
          showTitle: true,
        );
      },
    );
  }
}
