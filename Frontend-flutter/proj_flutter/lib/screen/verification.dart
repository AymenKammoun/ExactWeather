import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proj_flutter/main.dart';
import 'package:proj_flutter/network_utils/api.dart';
import 'package:proj_flutter/screen/login.dart';
import 'package:proj_flutter/screen/main_page.dart';
import 'package:proj_flutter/widgets/input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final verificationController = TextEditingController();
  String errorMessage = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email Verification"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            const Text(
              "We have send to your email a verification Mail",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              "containing a verification number",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 100,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "To continue copy it down below",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Input(
              title: "Verification",
              controller: verificationController,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => verify(),
              child: const Text("Verify"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Having troubels?'),
                  TextButton(
                    onPressed: () => resend(),
                    child: const Text(
                      'Resend email',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  verify() async {
    var data = {
      'verification_number': verificationController.text,
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (constext) => const Center(child: CircularProgressIndicator()),
    );

    var res = await Network().postData(data, '/verify');
    navigatorKey.currentState!.pop();
    var body = json.decode(res.body);
    if (body['success'] != null && body['success']) {
      Get.offAll(() => const MainPage());
    } else {
      setState(() {
        errorMessage = body["message"];
      });
    }
  }

  resend() async {
    var res = await Network().getData("/send_verification");
    var body = json.decode(res.body);
    if (body['success'] != null && body['success'] == false) {
      setState(() {
        errorMessage = body["message"];
      });
    }
  }

  back() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await Network().getData("/logout");
    localStorage.remove('user');
    localStorage.remove('token');
    localStorage.remove('email');
    Get.offAll(() => const Login());
  }
}
