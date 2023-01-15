import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:proj_flutter/network_utils/api.dart';
import 'package:proj_flutter/screen/check_verifyed.dart';
import 'package:proj_flutter/screen/main_page.dart';
import 'package:proj_flutter/main.dart';
import 'package:get/get.dart';
import 'package:proj_flutter/screen/register.dart';
import 'package:proj_flutter/widgets/button.dart';
import 'package:proj_flutter/widgets/input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = "";
  bool emailEmpty = false;
  bool passwordEmpty = false;
  bool _isObscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Login Page",
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
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                  prefixIcon: const Icon(Icons.email),
                  controller: emailController,
                  title: 'Email',
                  errorText: emailEmpty ? 'Email invalid!' : null,
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Button(
                  title: 'Login',
                  onPressed: signIn,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('New User?'),
                    TextButton(
                      onPressed: () => Get.to(() => const Register()),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signIn() async {
    var data = {
      'email': emailController.text,
      'password': passwordController.text
    };

    setState(() {
      emailEmpty = false;
      passwordEmpty = false;
    });
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

    var res = await Network().authData(data, '/login');
    navigatorKey.currentState!.pop();
    var body = json.decode(res.body);
    if (body['success'] != null && body['success']) {
      var data = body['data'];
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', data['token']);
      localStorage.setString('user', data['name']);
      localStorage.setString('email', data['email']);
      localStorage.setString('is_admin', data['is_admin'].toString());
      Get.offAll(() => const CheckVerified());
    } else {
      setState(() {
        errorMessage = body["message"];
      });
    }
  }
}
