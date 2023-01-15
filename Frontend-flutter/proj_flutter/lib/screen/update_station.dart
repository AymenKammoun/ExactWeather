import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proj_flutter/main.dart';
import 'package:proj_flutter/network_utils/api.dart';

import 'package:proj_flutter/screen/update_station_form.dart';

class UpdateStation extends StatefulWidget {
  const UpdateStation({super.key});

  @override
  State<UpdateStation> createState() => _UpdateStationState();
}

class _UpdateStationState extends State<UpdateStation> {
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
      appBar: AppBar(title: Text("Update Station")),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/6.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: stations.map((item) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      Get.to(() => UpdateStationForm(id: item['id'].toString()))
                          ?.then((_) => setState(() {
                                loadData();
                              }));
                      ;
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
          ),
        ),
      ),
    );
  }
}
