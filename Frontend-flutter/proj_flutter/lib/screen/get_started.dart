import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proj_flutter/screen/login.dart';
import 'package:proj_flutter/widgets/button.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/5-1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 130,
              margin: const EdgeInsets.only(top: 10),
              alignment: Alignment.topCenter,
              child: Image.asset("assets/logo1.png"),
            ),
            Image.asset(
              "assets/gettingStartedImage.png",
              height: 150,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 65),
              child: const Text(
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  "This weather app is one of best free weather apps with full features: Local weather, weather map (weather map service) and weather widgets."),
            ),
            Button(
              title: 'Get Started',
              onPressed: () {
                Get.to(() => const Login());
              },
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: const Text(
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800),
                  "© 2022 ExactWeather, Inc. All rights reserved."),
            ),
          ],
        ),
      ),
    );
  }
}
