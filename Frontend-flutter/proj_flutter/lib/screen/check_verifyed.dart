import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proj_flutter/network_utils/api.dart';
import 'package:proj_flutter/screen/verification.dart';
import 'package:proj_flutter/screen/main_page.dart';

class CheckVerified extends StatefulWidget {
  const CheckVerified({super.key});

  @override
  State<CheckVerified> createState() => _CheckVerifiedState();
}

class _CheckVerifiedState extends State<CheckVerified> {
  bool isVerified = false;
  bool checked = false;

  @override
  void initState() {
    _checkIfVerified();
    super.initState();
  }

  _checkIfVerified() async {
    var res = await Network().getData('/verified');
    var body = json.decode(res.body);
    if (body['success'] != null && body['success']) {
      setState(() {
        isVerified = true;
      });
    }
    setState(() {
      checked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (checked) {
      Widget next;
      if (isVerified) {
        next = const MainPage();
      } else {
        next = const Verification();
      }
      return next;
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
