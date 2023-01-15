import 'package:flutter/material.dart';
import 'package:proj_flutter/screen/main_page.dart';
import 'package:proj_flutter/screen/splash_loading.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      title: "ExactWeather",
      theme: ThemeData(primarySwatch: Palette.kToDark, fontFamily: 'Hubballi'),
      home: const SplashLoading(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xff154360, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff133c56), //10%
      100: Color(0xff11364d), //20%
      200: Color(0xff0f2f43), //30%
      300: Color(0xff0d283a), //40%
      400: Color(0xff0b2230), //50%
      500: Color(0xff081b26), //60%
      600: Color(0xff06141d), //70%
      700: Color(0xff040d13), //80%
      800: Color(0xff02070a), //90%
      900: Color(0xff000000), //100%
    },
  );
}
