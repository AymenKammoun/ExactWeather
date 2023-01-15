import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:proj_flutter/main.dart';
import 'package:proj_flutter/network_utils/api.dart';
import 'package:proj_flutter/screen/station_details.dart';

class ShowMap extends StatefulWidget {
  const ShowMap({super.key});

  @override
  State<ShowMap> createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  List<LatLng> points = [];

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
    stations = List.from(json.decode(res.body)["data"]);

    setState(() {
      for (var s in stations) {
        LatLng point =
            LatLng(double.parse(s["latitude"]), double.parse(s["longitude"]));
        points.add(point);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Show in Map",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(36.8925488, 10.1872409),
          zoom: 15,
        ),
        nonRotatedChildren: [
          AttributionWidget.defaultWidget(
            source: 'OpenStreetMap contributors',
            onSourceTapped: null,
          ),
        ],
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: points
                .map((e) => Marker(
                      point: e,
                      width: 80,
                      height: 80,
                      builder: (context) => InkWell(
                          onTap: () {
                            Get.to(() => StationDetails(
                                id: stations[points.indexOf(e)]["id"]
                                    .toString()));
                          },
                          child: Column(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    stations[points.indexOf(e)]["name"]
                                        .toString(),
                                    style: TextStyle(color: Colors.blue),
                                  )),
                              Icon(
                                Icons.location_on,
                                color: Colors.red,
                              ),
                            ],
                          )),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
