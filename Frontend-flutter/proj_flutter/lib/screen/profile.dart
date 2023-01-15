import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proj_flutter/main.dart';
import 'package:proj_flutter/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = "";
  String email = "";
  String status = "";
  var stations = [];
  var favoriteStation = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    await _loadUserData();
    await _loadStations();
  }

  _loadStations() async {
    var res = await Network().getData("/stations");
    setState(() {
      stations = List.from(json.decode(res.body)["data"]);
      for (var e in stations) {
        if (e["favorite"] == 1) {
          favoriteStation.add(e);
        }
      }
    });
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      name = localStorage.getString('user')!;
      email = localStorage.getString('email')!;
      status = (localStorage.getString('is_admin')!) == "1" ? "Admin" : "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: Container(
                width: double.infinity,
                height: 200,
                child: Container(
                  alignment: Alignment(0.0, 2.5),
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/profilem.png"),
                    radius: 60.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Text(
              name,
              style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.blueGrey,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              email,
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black45,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 8,
            ),
            Card(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                elevation: 2.0,
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    child: Text(
                      status,
                      style: TextStyle(
                          letterSpacing: 2.0, fontWeight: FontWeight.w300),
                    ))),
            Text(
              "Favourite stations ",
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black45,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w300),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: favoriteStation.map((e) {
                    return Expanded(
                      child: Column(
                        children: [
                          Text(
                            e["name"],
                            style: const TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            e["location"],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
