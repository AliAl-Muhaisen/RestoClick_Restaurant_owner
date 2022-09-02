// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> ar = {
  "appName": "RestoClick",
  "appName_Description": "المطعم المثالي بنقرة \nواحد فقط",
  "login": "تسجيل الدخول",
  "signup": "أنشاء حساب",
  "guest": "المتابعة كزائر",
  "inputForm": {
    "email": {
      "hintText": "example@gmail.com",
      "label": "ايميل",
      "errorMessage": {
        "invalid": "الرجاء إدخال عنوان بريد إلكتروني صالح"
      }
    },
    "password": {
      "label": "كلمة السر",
      "errorMessage": {
        "invalid": "يجب أن تحتوي كلمة المرور على رقم واحد وحرف واحد على الأقل",
        "short": "يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل"
      }
    },
    "userName": {
      "label": "أسم المستخدم",
      "hintText": "علي المحيسن",
      "errorMessage": {
        "invalid": "الرجاء إدخال عنوان اسم مستخدم صالح"
      }
    },
    "phoneNumber": {
      "label": "رقم الهاتف",
      "errorMessage": {
        "invalid": "الرجاء إدخال رقم هاتف صحيح"
      }
    }
  },
  "settingPage": {
    "accountSetting": "اعدادات الحساب",
    "logout": "تسجيل الخروج",
    "setting": "الاعدادات",
    "submit": "ارسال"
  },
  "showHttpDialog": {
    "buttonText": {
      "error": "اغلاق",
      "success": "حسنا"
    },
    "titleAndMessage": {
      "error": {
        "clientError": {
          "title": "خطا",
          "message": "هناك خطأ ما. الرجاء معاودة المحاولة في وقت لاحق."
        },
        "httpException": {}
      },
      "success": {
        "update": {
          "title": "تحديث",
          "message": "تم تحديث المعلومات بنجاح"
        }
      }
    }
  },
  "forgotPassword": {
    "dialog": {
      "title": "استرجاع"
    },
    "title": "هل نسيت كلمة المرور ؟",
    "snackBar": {
      "error": {
        "label": "هناك خطأ ما. حاول مرة اخرى"
      },
      "success": "تم ارسال البريد الالكتروني بنجاح"
    }
  }
};
static const Map<String,dynamic> en = {
  "appName": "RestoClick",
  "appName_Description": "The Perfect Restaurant is one \nclick away",
  "login": "Login",
  "signup": "Sign up",
  "guest": "Continue as Guest",
  "inputForm": {
    "email": {
      "hintText": "example@gmail.com",
      "label": "E-Mail",
      "errorMessage": {
        "invalid": "Please insert a valid email address"
      }
    },
    "password": {
      "label": "Password",
      "errorMessage": {
        "invalid": "the password should contain at least one number and one character",
        "short": "The password should contain at least 8 characters"
      }
    },
    "userName": {
      "label": "User Name",
      "hintText": "Ali Al-Muhaisen",
      "errorMessage": {
        "invalid": "Please enter a valid user name address"
      }
    },
    "phoneNumber": {
      "label": "Phone Number",
      "errorMessage": {
        "invalid": "Invalid Phone Number"
      }
    }
  },
  "settingPage": {
    "accountSetting": "Account Setting",
    "logout": "Logout",
    "setting": "Setting",
    "submit": "Submit"
  },
  "showHttpDialog": {
    "buttonText": {
      "error": "Close",
      "success": "Okay"
    },
    "titleAndMessage": {
      "error": {
        "clientError": {
          "title": "Error",
          "message": "Something went wrong. Please try again later."
        },
        "httpException": {}
      },
      "success": {
        "update": {
          "title": "Update",
          "message": "Information updated successfully"
        }
      }
    }
  },
  "forgotPassword": {
    "dialog": {
      "title": "Recovery"
    },
    "title": "Forgot Password ?",
    "snackBar": {
      "error": {
        "label": "Something went wrong. Please try again"
      },
      "success": "Email has been sent successfully"
    }
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ar": ar, "en": en};
}
