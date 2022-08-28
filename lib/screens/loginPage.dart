
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import '../models/http/auth.dart';
import '../models/screen.dart';
import '../models/user.dart';
import '../models/verify.dart';
import '../themes/stander/buttons.dart';
import '../translations/locale_keys.dart';
import '../widgets/inputFormField.dart';
import '../widgets/utils/addSpace.dart';
import '../widgets/utils/showDialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String routeName = '/LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  User user = User();
  InputFormField? email;
  InputFormField? password;
  @override
  void initState() {
    email = InputFormField(
      label: LocaleKeys.inputForm_email_label.tr(),
      inputIcon: Icons.email_outlined,
      keyBoardType: TextInputType.emailAddress,
      hintText: LocaleKeys.inputForm_email_hintText.tr(),
      validator: (String value) => Verify().isEMail(value),
      onSaved: (String value) => user.setEmail(value),
    );

    password = InputFormField(
      label: LocaleKeys.inputForm_password_label.tr(),
      inputIcon: Icons.shield,
      keyBoardType: TextInputType.visiblePassword,
      hintText: null,
      validator: (String value) => Verify().isUserName(value),
      onSaved: (String value) => user.setPassword(value),
    );
    super.initState();
  }

  Future<void> _submit() async {
    print('submitted form');
    if (!_formKey.currentState!.validate()) {
      print('invalid inputs');
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    print('user.email ${user.email}');
    print('user.password ${user.password}');
    setState(() {
      _isLoading = true;
    });
    try {
      print('try');

      await Provider.of<Auth>(context, listen: false)
          .login(user.email, user.password);
      Screen().pop(context);

      // showHttpDialog('Account created successfully', context);
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
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(verify.isPassword('asld'));
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              email!,
              password!,
              AddVerticalSpace(15),
              if (_isLoading)
                CircularProgressIndicator()
              else
                SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(LocaleKeys.login.tr()),
                    style: loginSignButtonStyle(radius: 20),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
