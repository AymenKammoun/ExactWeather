import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proj_flutter/main.dart';
import 'package:proj_flutter/network_utils/api.dart';
import 'package:proj_flutter/widgets/button.dart';
import 'package:proj_flutter/widgets/input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final usernameController = TextEditingController();

  String errorMessage = "";
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  @override
  void dispose() {
    emailController.dispose();
    newPasswordController.dispose();
    oldPasswordController.dispose();
    usernameController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = localStorage.getString('email')!;
      usernameController.text = localStorage.getString('user')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 244, 245, 226),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/background.jpg"),
                        fit: BoxFit.cover)),
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Container(
                    alignment: const Alignment(0.0, 2.5),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage("assets/profilem.png"),
                      radius: 60.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              const Text(
                "Edit profile",
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.blueGrey,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Input(
                  controller: usernameController,
                  title: 'Username',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Input(
                  controller: emailController,
                  title: 'Email',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Input(
                  controller: oldPasswordController,
                  title: 'Old Password',
                  password: true,
                  isObscure: _isObscure1,
                  onShow: () {
                    setState(() {
                      _isObscure1 = !_isObscure1;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Input(
                  controller: newPasswordController,
                  title: 'New Password',
                  password: true,
                  isObscure: _isObscure2,
                  onShow: () {
                    setState(() {
                      _isObscure2 = !_isObscure2;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Button(
                  title: 'Confirm',
                  onPressed: confirm,
                ),
              ),
              Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void confirm() async {
    var data = {
      'email': emailController.text,
      'name': usernameController.text,
      'old_password': oldPasswordController.text,
      'new_password': newPasswordController.text,
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (constext) => const Center(child: CircularProgressIndicator()),
    );

    var res = await Network().postData(data, '/update_user');
    navigatorKey.currentState!.pop();
    var body = json.decode(res.body);
    if (body['success'] != null && body['success']) {
      var data = body['data'];
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('user', data['name']);
      localStorage.setString('email', data['email']);
      Get.back();
    } else {
      setState(() {
        errorMessage = body["message"];
      });
    }
  }
}
