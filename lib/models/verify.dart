import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../translations/locale_keys.dart';

class Verify {
  static final Verify _verify = Verify._internal();
  factory Verify() {
    return _verify;
  }
  Verify._internal();

  String? isEMail(String? email) {
    // to check if the email address valid or not
    email = email!.trim();
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return LocaleKeys.inputForm_userName_errorMessage_invalid.tr();
    }
    return null;
  }

  String? isPassword(String? password) {
    if (password!.length < 8) {
      return LocaleKeys.inputForm_password_errorMessage_short.tr();
    }
    if (!RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}").hasMatch(password)) {
      return LocaleKeys.inputForm_password_errorMessage_invalid.tr();
    }
    return null;
    // if(password.isNotEmpty && password.length>7 && password.a)

    // return false;
  }

  String? isPhoneNumber(String? phoneNumber) {
    List<String> validInputs = [
      '+',
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
    ];
    var digits = phoneNumber!.trim().split('');
    if (digits.length < 7 || digits.length > 25) {
      return LocaleKeys.inputForm_phoneNumber_errorMessage_invalid.tr();

      // return '<7';
    }
    // if (digits.length > 25) {
    //   return '>25';
    // }
    digits.map((digit) {
      if (!digits.contains(digit)) {
        return LocaleKeys.inputForm_phoneNumber_errorMessage_invalid.tr();
      }
    });

    return null;
  }

  String? isUserName(String? name) {
    if (!RegExp(r"^[a-zA-Z\d._-]{3,20}").hasMatch(name!)) {
      return LocaleKeys.inputForm_userName_errorMessage_invalid.tr();
    }
    return null;
  }
}
