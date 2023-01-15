import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proj_flutter/network_utils/api.dart';
import 'package:proj_flutter/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proj_flutter/screen/update_profile.dart';
import 'package:proj_flutter/screen/update_station.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/wea2.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Center(
                    child: Image.asset(
                      'assets/logo1.png',
                      scale: 2,
                    ),
                  ),
                ),
                const Text(
                  "Settings",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 40),
                Card(
                  color: Colors.white.withAlpha(200),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => UpdateProfile());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 116, 205, 230),
                            ),
                            child: const Icon(
                              Icons.manage_accounts,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Account",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: Colors.white.withAlpha(200),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => UpdateStation());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 116, 205, 230),
                            ),
                            child: const Icon(Icons.add_location_alt,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Stations",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: Colors.white.withAlpha(200),
                  child: InkWell(
                    onTap: () => logout(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 116, 205, 230),
                            ),
                            child: const Icon(Icons.logout_outlined,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  void logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await Network().getData("/logout");
    localStorage.remove('user');
    localStorage.remove('token');
    localStorage.remove('email');
    Get.offAll(() => const Login());
  }
}
