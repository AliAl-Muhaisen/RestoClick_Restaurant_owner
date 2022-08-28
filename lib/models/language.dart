// import 'package:customer_app/translations/locale_keys.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

class Language with ChangeNotifier {
  // static Language? _language = null;
  // final String id;
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
    print('from function change ${context.locale.toString()}');
    if (cl) {
      print('arabic + ${context.locale.toString()}');
      await context.setLocale(Locale('ar'));
    } else {
      print('english + ${context.locale.toString()}');
  
      await context.setLocale(Locale('en'));
    }
    cl = !cl;

    // notifyListeners();
    print('from function change ${context.locale.toString()} 2');
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
  void a() {
    
    notifyListeners();
  }
 
}

