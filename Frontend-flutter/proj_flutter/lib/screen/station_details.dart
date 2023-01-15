import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proj_flutter/main.dart';
import 'package:proj_flutter/network_utils/api.dart';
import 'package:proj_flutter/screen/show_statistics.dart';
import 'package:proj_flutter/widgets/button.dart';

class StationDetails extends StatefulWidget {
  const StationDetails({super.key, required this.id});
  final String id;

  @override
  State<StationDetails> createState() => _StationDetailsState();
}

class _StationDetailsState extends State<StationDetails> {
  var station = {};
  var tempretureData = {};
  var humidityData = {};
  var luminosityData = {};
  var pressureData = {};

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
    await _getMesurments();

    navigatorKey.currentState!.pop();
  }

  _getStationData() async {
    var res = await Network().getData("/station/${widget.id}");
    setState(() {
      station = json.decode(res.body)["data"];
    });
  }

  _getMesurments() async {
    var res = await Network()
        .authData({"latest": "true"}, "/influxdb/get/temperature");
    setState(() {
      tempretureData = json.decode(res.body)["data"];
    });

    res = await Network()
        .authData({"latest": "true"}, "/influxdb/get/luminosity");
    setState(() {
      luminosityData = json.decode(res.body)["data"];
    });

    res =
        await Network().authData({"latest": "true"}, "/influxdb/get/humidity");
    setState(() {
      humidityData = json.decode(res.body)["data"];
    });

    res =
        await Network().authData({"latest": "true"}, "/influxdb/get/pressure");
    setState(() {
      pressureData = json.decode(res.body)["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Station details"),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 13, 159, 175),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/8.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 5,
            ),
            Text(
              station["location"] != null ? station["location"].toString() : "",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 35,
              ),
            ),
            Text(
              tempretureData.isNotEmpty ? tempretureData.keys.first : "",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 20,
              ),
            ),
            Image.asset(
              "assets/cloudy.png",
              width: 150,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Partly Cloudy",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "${tempretureData.isNotEmpty ? tempretureData[tempretureData.keys.first] : ""}°C",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              color: Colors.white.withAlpha(200),
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Image(
                          image: AssetImage("assets/lum.jpg"),
                          width: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                              "${luminosityData.isNotEmpty ? luminosityData[luminosityData.keys.first] : ""} Lux"),
                        ),
                        const Text("Luminosity"),
                      ],
                    ),
                    Column(
                      children: [
                        const Image(
                          image: AssetImage("assets/humidity.png"),
                          width: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                              "${humidityData.isNotEmpty ? humidityData[humidityData.keys.first] : ""}%"),
                        ),
                        const Text("Humidity"),
                      ],
                    ),
                    Column(
                      children: const [
                        Image(
                          image: AssetImage("assets/rain.png"),
                          width: 50,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text("--- mm")),
                        Text("Precipitations"),
                      ],
                    ),
                    Column(
                      children: [
                        const Image(
                          image: AssetImage("assets/hana21.jpg"),
                          width: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                              "${pressureData.isNotEmpty ? pressureData[pressureData.keys.first] : ""} mbar"),
                        ),
                        const Text("Pressure"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Button(
                title: "Show statistics",
                fontSize: 18,
                onPressed: () {
                  Get.to(() => ShowStatistics(id: widget.id));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Button(
                title: "Show Predictions",
                onPressed: () {},
                fontSize: 18,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
