import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import '../translations/locale_keys.dart';

class Verify {
  ///*? info
  ///*? void = - and get = + setAndGet =
  ///*# Functions
  ///*$ + isPrice
  ///*$ + isImage
  ///*$ + isAddress
  ///*$ + isRestaurantName
  ///*$ + isEMail
  ///*$ + isPassword
  ///*$ + isPhoneNumber
  ///*$ + isUserName

  static final Verify _verify = Verify._internal();

  /// To validate the input
  factory Verify() {
    return _verify;
  }
  Verify._internal();
  List<String> validInputsNumber = [
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

  /// To validate the Price
  String? isPrice({String? price}) {
    var digits = price!.trim().split('');
    if (digits.isEmpty || digits.length > 5) {
      return "please enter a valid price";
    }
    digits.map((digit) {
      if (!validInputsNumber.contains(digit)) {
        return "please enter a valid price";
      }
    });

    return null;
  }

  /// To validate the Image
  String? isImage(File? file) {
    if (file == null) {
      return "Uploaded file is not a valid image";
    }
    return null;
  }

  /// To validate the Address
  String? isAddress(String? address) {
    if (address!.length < 3 || address.isEmpty) {
      return "invalid address";
    }
    return null;
  }

  /// To validate the Restaurant Name
  String? isRestaurantName(String? restaurantName) {
    if (restaurantName!.length < 3 || restaurantName.isEmpty) {
      return "invalid name";
    }
    return null;
  }

  /// To validate the EMail
  String? isEMail(String? email) {
    // to check if the email address valid or not
    email = email!.trim();
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return LocaleKeys.inputForm_email_errorMessage_invalid.tr();
    }
    return null;
  }

  /// To validate the Password
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

  /// To validate the Phone Number
  String? isPhoneNumber(String? phoneNumber) {
    List<String> validInputs = [
      '+',
      ...validInputsNumber,
    ];
    var digits = phoneNumber!.trim().split('');
    if (digits.length < 7 || digits.length > 25) {
      return LocaleKeys.inputForm_phoneNumber_errorMessage_invalid.tr();

      // return '<7';
    }

    digits.map((digit) {
      if (!digits.contains(digit)) {
        return LocaleKeys.inputForm_phoneNumber_errorMessage_invalid.tr();
      }
    });

    return null;
  }

  /// To validate the User Name
  String? isUserName(String? name) {
    if (!RegExp(r"^[a-zA-Z\d._-]{3,20}").hasMatch(name!)) {
      return LocaleKeys.inputForm_userName_errorMessage_invalid.tr();
    }
    return null;
  }

  String? isReport(String report) {
    String value = report.trim();
    if (value.length < 20 || value.length > 110) {
      return "Please enter a Suggestion between 20-110 letter";
    }
    return null;
  }
}
