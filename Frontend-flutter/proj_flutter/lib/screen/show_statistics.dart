import 'dart:async';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:proj_flutter/main.dart';
import 'package:proj_flutter/network_utils/api.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:html' as html;
import 'package:intl/intl.dart';

class ShowStatistics extends StatefulWidget {
  const ShowStatistics({super.key, required this.id});
  final String id;

  @override
  State<ShowStatistics> createState() => _ShowStatisticsState();
}

class _ShowStatisticsState extends State<ShowStatistics> {
  var station = {};
  var mesurmentsData = {};
  bool error = false;
  var mesurments = [
    "Precipitations",
    "Pressure",
    "Humidity",
    "Luminosity",
    "Temperature"
  ];
  String dropdownvalue = "Temperature";
  DateTime selectedDate = DateTime(2023, 1, 9);

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
    String start =
        selectedDate.millisecondsSinceEpoch.toString().substring(0, 10);
    String end = selectedDate
        .add(const Duration(days: 1))
        .millisecondsSinceEpoch
        .toString()
        .substring(0, 10);

    var res = await Network().authData({
      "latest": "false",
      "start": start,
      "stop": end,
    }, "/influxdb/get/${dropdownvalue.toLowerCase()}");

    if (json.decode(res.body)["success"]) {
      setState(() {
        error = false;
        mesurmentsData = json.decode(res.body)["data"];
      });
    } else {
      setState(() {
        error = true;
        mesurmentsData = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Mesurment> data = [];
    int i = 0;
    for (var key in mesurmentsData.keys) {
      data.add(Mesurment(
          key.toString(), double.parse(mesurmentsData[key].toString())));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Station Statistics"),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 13, 159, 175),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/6.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                "Date: ${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2022, 12, 10),
                    lastDate: DateTime.now(),
                  );
                  setState(() {
                    selectedDate = newDate!;
                  });

                  await loadData();
                },
                child: const Text(
                  "Select Date",
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Select mesurment",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: DropdownButton(
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: mesurments.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                        loadData();
                      });
                    },
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: "$dropdownvalue Graph"),
                legend: Legend(isVisible: false),
                backgroundColor: Colors.white,
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<Mesurment, String>>[
                  LineSeries(
                    dataSource: data,
                    xValueMapper: (datum, index) => datum.x,
                    yValueMapper: (datum, index) => datum.y,
                    name: "Temp",
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            error
                ? const Text(
                    "Data not found!",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  )
                : Container(),
            ElevatedButton(
              onPressed: () {
                _downloadCsvFile(false);
              },
              child: const Text("Generate csv"),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadCsvFile(bool withBom) {
    final bom = '\uFEFF'; // Byte Order Mark: [0xEF] [0xBB] [0xBF]
    var dummy = ["Date, $dropdownvalue"];
    for (var key in mesurmentsData.keys) {
      dummy.add("$key, ${mesurmentsData[key]}");
    }

    String text;
    if (withBom) {
      text = bom + dummy.join("\n");
    } else {
      text = dummy.join("\n");
    }

    // prepare
    final bytes = utf8.encode(text);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'Graph$formattedDate.csv';
    html.document.body?.children.add(anchor);

    // download
    anchor.click();

    // cleanup
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}

class Mesurment {
  String x;
  double y;
  Mesurment(this.x, this.y);
}
