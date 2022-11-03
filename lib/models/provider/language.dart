// import 'package:customer_app/translations/locale_keys.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

class Language with ChangeNotifier {
  /// Class Variables
  final String flag;
  final String languageCode;
  final String name;
  static bool cl = false;
  Language({
    required this.name,
    required this.flag,
    required this.languageCode,
  }) {}
  static Future<void> changeLanguage(
    String languageCode,
    BuildContext context,
  ) async {
    log('from function change ${context.locale.toString()}');
    if (cl) {
      log('arabic + ${context.locale.toString()}');
      await context.setLocale(const Locale('ar'));
    } else {
      log('english + ${context.locale.toString()}');

      await context.setLocale(const Locale('en'));
    }
    cl = !cl;

    // notifyListeners();
    log('from function change ${context.locale.toString()} 2');
  }

  final supportedLocales = const [
    Locale('en'),
    Locale('ar'),
  ];

  static List<Language> languageList = [
    Language(
      name: 'العربية',
      flag: '🇸🇦',
      languageCode: 'ar',
    ),
    Language(
      name: 'English',
      flag: '🇺🇸',
      languageCode: 'en',
    ),
  ];
}
