import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/provider/auth.dart';
import '../models/screen.dart';
import '../translations/locale_keys.dart';
import '../widgets/account/accountWidget.dart';
import '../widgets/utils/addSpace.dart';
import 'EditAccount.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AddVerticalSpace(20),
            const Text('Profile'),
            AddVerticalSpace(20),
            ProfilePic(),
            AddVerticalSpace(20),
            CardSetting(
              icon: Icons.manage_accounts_outlined,
              onPressed: () {
                Screen().pushNamed(context, EditAccount.routeName);
              },
              text: LocaleKeys.settingPage_accountSetting.tr(),
            ),
            CardSetting(
              icon: Icons.logout,
              onPressed: () async {
                Provider.of<Auth>(context, listen: false).logout();
                //Screen().pop(context);
              },
              text: LocaleKeys.settingPage_logout.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
