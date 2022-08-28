import 'package:flutter/material.dart';

import '../themes/stander/text.dart';

class SplashPage extends StatelessWidget {

  static const routeName='/splashPage';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Loading... from splash screen',
          style: appNameTextStyle,
        ),
      ),
    );
  }
}
