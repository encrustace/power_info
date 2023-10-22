import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:power_info/provider.dart';
import 'package:power_info/view/battery_details.dart';
import 'package:power_info/view/drain_timeline.dart';
import 'package:provider/provider.dart';
import 'package:upower/upower.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UPowerDevice> batteyList = [];
  late RootProvider provider;
  static const List<Widget> pageList = [
    BatteryDetails(),
    DrainTimeline(),
  ];
  int selectedPage = 0;
  changePage(index) {
    setState(() {
      selectedPage = index;
    });
  }

  Future<void> getBatteryList() async {
    provider = Provider.of<RootProvider>(context, listen: false);
    var client = UPowerClient();
    await client.connect();
    setState(() {
      batteyList = client.devices;
      provider.setSelectedBattery(batteyList[0]);
    });
  }

  @override
  void initState() {
    getBatteryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (batteyList.isNotEmpty) {
      return Scaffold(
          body: Row(
        children: [
          Container(
            width: 200,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(width: 0.2, color: Colors.black),
              ),
            ),
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 32, bottom: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownMenu<UPowerDevice>(
                  enableSearch: true,
                  enableFilter: false,
                  enabled: true,
                  width: 184,
                  label: const Text(
                    "Battery",
                    style: TextStyle(fontSize: 16),
                  ),
                  dropdownMenuEntries:
                      batteyList.map<DropdownMenuEntry<UPowerDevice>>((device) {
                    return DropdownMenuEntry(
                      value: device,
                      label:
                          "${device.vendor} ${device.model} ${device.nativePath}",
                    );
                  }).toList(),
                  onSelected: (value) {
                    provider.setSelectedBattery(value!);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextButton(
                  onPressed: () {
                    changePage(0);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        FontAwesomeIcons.info,
                        size: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Details",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextButton(
                  onPressed: () {
                    changePage(1);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.chartLine,
                        size: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Drain Stats",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: pageList[selectedPage],
          ))
        ],
      ));
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
