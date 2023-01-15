import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:proj_flutter/network_utils/api.dart';
import 'package:proj_flutter/screen/check_verifyed.dart';
import 'package:proj_flutter/screen/main_page.dart';
import 'package:proj_flutter/main.dart';
import 'package:get/get.dart';
import 'package:proj_flutter/screen/verification.dart';
import 'package:proj_flutter/widgets/button.dart';
import 'package:proj_flutter/widgets/input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  bool usernameEmpty = false;
  bool emailEmpty = false;
  bool passwordEmpty = false;
  bool _isObscure = true;

  String errorMessage = "";
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Register Page",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Center(
                  child: Image.asset(
                    'assets/logo1.png',
                    scale: 2,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    "Welcome to ExactWeather",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Input(
                  controller: usernameController,
                  title: 'Username',
                  errorText: usernameEmpty ? 'Username invalid!' : null,
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Input(
                  controller: emailController,
                  title: 'Email',
                  errorText: usernameEmpty ? 'Email invalid!' : null,
                  prefixIcon: const Icon(Icons.mail),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Input(
                    prefixIcon: const Icon(Icons.lock),
                    controller: passwordController,
                    title: 'Password',
                    errorText: passwordEmpty ? 'Password invalid!' : null,
                    password: true,
                    isObscure: _isObscure,
                    onShow: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
              Button(
                title: "Register",
                onPressed: signUp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp() async {
    var data = {
      'name': usernameController.text,
      'email': emailController.text,
      'password': passwordController.text
    };

    setState(() {
      emailEmpty = false;
      passwordEmpty = false;
      usernameEmpty = false;
    });
    if (usernameController.text.isEmpty) {
      setState(() {
        usernameEmpty = true;
      });
      return;
    }
    if (emailController.text.isEmpty) {
      setState(() {
        emailEmpty = true;
      });
      return;
    }
    if (passwordController.text.isEmpty) {
      setState(() {
        passwordEmpty = true;
      });
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (constext) => const Center(child: CircularProgressIndicator()),
    );

    var res = await Network().authData(data, '/register');
    navigatorKey.currentState!.pop();
    var body = json.decode(res.body);
    if (body['success']) {
      var data = body['data'];
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', data['token']);
      localStorage.setString('user', data['name']);
      localStorage.setString('email', data['email']);
      localStorage.setString('is_admin', data['is_admin'].toString());
      Network().getData("/send_verification");
      Get.off(() => const Verification());
    } else {
      setState(() {
        errorMessage = body["message"];
      });
    }
  }
}
