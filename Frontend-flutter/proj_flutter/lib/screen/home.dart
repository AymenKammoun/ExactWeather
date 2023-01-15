import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:proj_flutter/screen/all_stations.dart';
import 'package:proj_flutter/screen/show_map.dart';
import 'package:proj_flutter/widgets/button.dart';
import 'package:proj_flutter/widgets/input.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool visible = true;
  double searchMarginH = 60;
  double searchMarginT = 20;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/6.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: visible,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Center(
                      child: Image.asset(
                        'assets/logo1.png',
                        scale: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: visible,
              child: Image.asset(
                "assets/Capture-Map.jpg",
                scale: 1.5,
              ),
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              margin: EdgeInsets.only(
                  left: searchMarginH,
                  right: searchMarginH,
                  top: searchMarginT),
              child: Focus(
                onFocusChange: (value) {
                  setState(() {
                    visible = !value;
                    if (value) {
                      searchMarginH = 15;
                      searchMarginT = 20;
                    } else {
                      searchMarginH = 60;
                      searchMarginT = 20;
                    }
                  });
                },
                child: Input(
                  title: "Search",
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Visibility(
                visible: !visible,
                child: Container(
                  width: 300,
                  color: Colors.white,
                  child: Column(
                    children: const [
                      Text("Station1"),
                      Text("Station2"),
                    ],
                  ),
                )),
            Visibility(
              visible: visible,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Button(
                      title: "Show All",
                      fontSize: 18,
                      onPressed: () {
                        Get.to(() => const AllStations());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Button(
                      title: "Show in map",
                      fontSize: 18,
                      onPressed: () {
                        Get.to(() => const ShowMap());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
