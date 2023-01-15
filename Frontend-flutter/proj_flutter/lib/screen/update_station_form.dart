import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proj_flutter/main.dart';
import 'package:proj_flutter/network_utils/api.dart';
import 'package:proj_flutter/widgets/button.dart';
import 'package:proj_flutter/widgets/input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class UpdateStationForm extends StatefulWidget {
  const UpdateStationForm({super.key, required this.id});
  final String id;

  @override
  State<UpdateStationForm> createState() => _UpdateStationFormState();
}

class _UpdateStationFormState extends State<UpdateStationForm> {
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  var station = {};
  bool state = false;
  bool favorite = false;
  bool admin = false;

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (constext) => const Center(child: CircularProgressIndicator()),
      );
    });
    await _getStationData();
    await _loadUserData();
    navigatorKey.currentState!.pop();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      admin = (localStorage.getString('is_admin')!) == "1";
    });
  }

  _getStationData() async {
    var res = await Network().getData("/station/${widget.id}");
    setState(() {
      station = json.decode(res.body)["data"];
      nameController.text = station["name"].toString();
      locationController.text = station["location"].toString();
      state = station["state"] == 1;
      favorite = station["favorite"] == 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Edit Sation",
      )),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/149.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Input(
                  enabled: admin,
                  controller: nameController,
                  title: 'Name',
                  errorText: null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Input(
                  enabled: admin,
                  controller: locationController,
                  title: 'Location',
                  errorText: null,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Visibility(
                visible: admin,
                child: ToggleSwitch(
                  minWidth: 50.0,
                  cornerRadius: 20.0,
                  activeBgColors: [
                    [Colors.green[800]!],
                    [Colors.red[800]!]
                  ],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  initialLabelIndex: state ? 0 : 1,
                  totalSwitches: 2,
                  labels: const ['On', 'Off'],
                  radiusStyle: true,
                  onToggle: (index) {
                    state = index == 1 ? false : true;
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ToggleSwitch(
                minWidth: 150.0,
                cornerRadius: 20.0,
                activeBgColors: const [
                  [Color.fromARGB(255, 165, 153, 39)],
                  [Color.fromARGB(255, 31, 31, 31)]
                ],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                initialLabelIndex: favorite ? 0 : 1,
                totalSwitches: 2,
                labels: const ['Favorite', 'Not favorite'],
                radiusStyle: true,
                onToggle: (index) {
                  favorite = index == 1 ? false : true;
                },
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Button(
                  title: 'Update',
                  onPressed: update,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void update() async {
    var data = {
      'name': nameController.text,
      'location': locationController.text,
      'state': state ? 1 : 0
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (constext) => const Center(child: CircularProgressIndicator()),
    );

    if (favorite) {
      await Network().getData('/add_to_favorite/${widget.id}');
    } else {
      await Network().getData('/remove_from_favorite/${widget.id}');
    }
    if (!admin) {
      setState(() {
        Get.back();
      });
    }

    var res = await Network().postData(data, '/station/${widget.id}');
    navigatorKey.currentState!.pop();
    var body = json.decode(res.body);
    if (body['success']) {
      setState(() {
        Get.back();
      });
    }
  }
}
