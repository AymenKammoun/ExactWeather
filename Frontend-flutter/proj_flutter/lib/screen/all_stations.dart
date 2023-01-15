import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proj_flutter/main.dart';
import 'package:proj_flutter/network_utils/api.dart';
import 'package:proj_flutter/screen/station_details.dart';

class AllStations extends StatefulWidget {
  const AllStations({super.key});

  @override
  State<AllStations> createState() => _AllStationsState();
}

class _AllStationsState extends State<AllStations> {
  var stations = [];

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
    await _loadStations();
    navigatorKey.currentState!.pop();
  }

  _loadStations() async {
    var res = await Network().getData("/stations");
    setState(() {
      stations = List.from(json.decode(res.body)["data"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Stations"),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/6.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              children: stations.map((item) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      Get.to(() => StationDetails(id: item['id'].toString()));
                    },
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: item["favorite"] == 1
                                    ? Colors.yellow
                                    : Colors.grey,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(item["name"]),
                            ],
                          ),
                          Icon(
                            Icons.circle,
                            color:
                                item["state"] == 1 ? Colors.green : Colors.red,
                          ),
                        ],
                      ),
                      tileColor: Color.fromARGB(255, 191, 202, 202),
                    ),
                  ),
                );
              }).toList(),
            ),
          )),
    );
  }
}
