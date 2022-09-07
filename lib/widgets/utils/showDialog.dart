import 'dart:developer';

import '../../translations/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/provider/auth.dart';
import '../../models/http/http_exception.dart';
import '../../models/screen.dart';
import '../../models/verify.dart';
import '../inputFormField.dart';

void showHttpDialog(
  String title,
  String message,
  String buttonText,
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      elevation: 5,
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text(buttonText),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}

class ForgotPasswordButton extends StatefulWidget {
  const ForgotPasswordButton({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordButton> createState() => _ForgotPasswordButtonState();
}

class _ForgotPasswordButtonState extends State<ForgotPasswordButton> {
  final GlobalKey<FormState> _formKeyShowDialog = GlobalKey<FormState>();
  bool _isLoading = false;
  InputFormField? email;
  SnackBar? snackBar;
  @override
  void initState() {
    email = InputFormField(
      label: LocaleKeys.inputForm_email_label.tr(),
      inputIcon: Icons.email_outlined,
      keyBoardType: TextInputType.emailAddress,
      hintText: LocaleKeys.inputForm_email_hintText.tr(),
      validator: (String value) => Verify().isEMail(value),
      onSaved: (String value) => value,
      enabledBorderRadius: 5,
      focusedBorderRadius: 10,
    );

    snackBar = SnackBar(
      content: Text(LocaleKeys.forgotPassword_snackBar_success.tr()),
      action: SnackBarAction(
        label: LocaleKeys.showHttpDialog_buttonText_success.tr(),
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void onPressed() {
    Future<void> _submit(setState) async {
      if (!_formKeyShowDialog.currentState!.validate()) {
        log('invalid inputs');
        // Invalid!
        return;
      }
      _formKeyShowDialog.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Auth>(context, listen: false)
            .forgotPassword(email!.inputController!.text);
        log('submitted form');

        Screen().pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar!);
      } on HttpException catch (error) {
        var errorMessage = 'Authentication failed';
        if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'This email address is already in use.';
        }
        //else if (error.toString().contains('INVALID_EMAIL')) {
        //     errorMessage = 'This is not a valid email address';
        //   } else if (error.toString().contains('WEAK_PASSWORD')) {
        //     errorMessage = 'This password is too weak.';
        //   }
      } catch (error) {
        log('error');
        log(error.toString());
        showHttpDialog(
          LocaleKeys.showHttpDialog_titleAndMessage_error_clientError_title
              .tr(),
          LocaleKeys.showHttpDialog_titleAndMessage_error_clientError_message
              .tr(),
          LocaleKeys.showHttpDialog_buttonText_error.tr(),
          context,
        );
      }
      setState(() {
        _isLoading = false;
      });
    }

    showDialog(
      context: context,
      builder: (context) =>
          StatefulBuilder(builder: (context, StateSetter setState) {
        return AlertDialog(
          title: const Text('Reset Password'),
          elevation: 5,
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Form(
            key: _formKeyShowDialog,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(LocaleKeys.inputForm_email_label.tr()),
                Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(225, 207, 198, 198),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: email!,
                ),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: () => _submit(setState),
                    child: Text(LocaleKeys.settingPage_submit.tr()),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            onPressed();
          },
          child: Text(
            LocaleKeys.forgotPassword_title.tr(),
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}

void showDialogResetPassword(BuildContext context) {
  final GlobalKey<FormState> _formKeyShowDialog = GlobalKey<FormState>();
  bool _isLoading = false;
  InputFormField email = InputFormField(
    label: LocaleKeys.inputForm_email_label.tr(),
    inputIcon: Icons.email_outlined,
    keyBoardType: TextInputType.emailAddress,
    hintText: LocaleKeys.inputForm_email_hintText.tr(),
    validator: (String value) => Verify().isEMail(value),
    onSaved: (String value) => value,
    enabledBorderRadius: 5,
    focusedBorderRadius: 10,
  );
  Future<void> _submit() async {
    log('submitted form');
    if (!_formKeyShowDialog.currentState!.validate()) {
      log('invalid inputs');
      // Invalid!
      return;
    }
    _formKeyShowDialog.currentState!.save();
    try {
      log('email -> ${email.inputController!.text}');
      await Provider.of<Auth>(context, listen: false)
          .forgotPassword(email.inputController!.text);

      Screen().pop(context);
    } catch (error) {
      print('error');
      print(error);
      showHttpDialog(
        LocaleKeys.showHttpDialog_titleAndMessage_error_clientError_title.tr(),
        LocaleKeys.showHttpDialog_titleAndMessage_error_clientError_message
            .tr(),
        LocaleKeys.showHttpDialog_buttonText_error.tr(),
        context,
      );
      // CircularProgressIndicator();
    }
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Reset Password'),
      elevation: 5,
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: Form(
        key: _formKeyShowDialog,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(LocaleKeys.inputForm_email_label.tr()),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(225, 207, 198, 198),
                borderRadius: BorderRadius.circular(7),
              ),
              child: email,
            ),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () => _submit(),
                child: Text(LocaleKeys.settingPage_submit.tr()),
              ),
          ],
        ),
      ),
    ),
  );
}
