import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../models/provider/language.dart';


Widget LanguageDropButton(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(
      horizontal: 27,
    ),
    child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: DropdownButton(
       

        icon: const Icon(
          Icons.language,
          color: Color.fromARGB(255, 238, 231, 231),
        ),

        items: Language.languageList
            .map(
              (lang) => DropdownMenuItem(
                value: lang,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(child: Text(lang.name), width: null),
                    Text(lang.flag),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: (Language? language) async {
          print(language!.languageCode);
          await context.setLocale(Locale(language.languageCode));
        },
      ),
    ),
  );
}

