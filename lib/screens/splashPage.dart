import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:restaurant_owner_app/widgets/utils/addSpace.dart';

import '../themes/stander/text.dart';
import '../widgets/loadingSpin.dart';

class SplashPage extends StatelessWidget {
  static const routeName = '/splashPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/App_Logo.png'),
              AddVerticalSpace(10),
              spinKitLoading(),
            ],
          ),
        ),
      ),
    );
  }
}
