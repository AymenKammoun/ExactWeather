import 'package:flutter/material.dart';
import 'package:proj_flutter/screen/check_verifyed.dart';
import 'package:proj_flutter/screen/get_started.dart';
import 'package:proj_flutter/screen/verification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proj_flutter/screen/main_page.dart';

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget next;
    if (isAuth) {
      next = const CheckVerified();
    } else {
      next = const GetStarted();
    }
    return next;
  }
}
