import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:power_info/view/battery_details.dart';
import 'package:power_info/view/drain_timeline.dart';
import 'package:upower/upower.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Container(
          width: 180,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 0.2, color: Colors.black),
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
  }
}
