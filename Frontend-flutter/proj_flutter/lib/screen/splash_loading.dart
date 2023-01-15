// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:proj_flutter/screen/check_auth.dart';

class SplashLoading extends StatelessWidget {
  const SplashLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: const CheckAuth(),
      imageBackground: const AssetImage("assets/1.jpg"),
      photoSize: 200,
      image: Image.asset(
        "assets/logo1.png",
      ),
      loadingText: const Text(
        "© 2022 ExactWeather, Inc. All rights reserved.",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      ),
      useLoader: true,
      loaderColor: Color.fromARGB(255, 10, 33, 52),
    );
  }
}
