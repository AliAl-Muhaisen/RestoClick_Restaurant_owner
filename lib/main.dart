import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'models/provider/restaurant/restaurantMenu.dart';


import 'models/provider/auth.dart';
import 'models/provider/restaurant/meal.dart';
import 'models/screen.dart';
import 'screens/mainPage.dart';
import 'screens/splashPage.dart';
import 'themes/stander/colors.dart';
import 'translations/codegen_loader.g.dart';
import 'widgets/utils/floatingNavbar.dart';

Future<void> main() async {
  await dotenv.load(
    fileName: "assets/.env",
  );

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  //
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 0, 0, 0),
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      fallbackLocale: const Locale('en'),
      assetLoader:const CodegenLoader(),
      child: MyApp(),
    ),
  );
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  //? This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => RestaurantMenu()),
        ChangeNotifierProvider(create: (context) => Meal()),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor:backgroundColor,//Color.fromARGB(255, 243, 235, 235),
          ),

          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routes: Screen().routes,
          // home: MyHomePage(),
          home: auth.isAuth
              ?const FloatingNavbar()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (
                    context,
                    authResultSnapShot,
                  ) =>
                      authResultSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? SplashPage()
                          :const MyHomePage(),
                ),
        ),
      ),
    );
  }
}
//test@test.com

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainPage();
  }
}
