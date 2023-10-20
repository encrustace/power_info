import 'package:flutter/material.dart';
import 'package:power_info/model/key_value_model.dart';
import 'package:upower/upower.dart';

class BatteryDetails extends StatefulWidget {
  const BatteryDetails({super.key});

  @override
  State<BatteryDetails> createState() => _BatteryDetailsState();
}

class _BatteryDetailsState extends State<BatteryDetails> {
  List<KeyValueModel> dataList = [];

  Future<void> getBattery() async {
    var client = UPowerClient();
    await client.connect();
    UPowerDevice device = client.devices[0];
    dataList.add(KeyValueModel("UPower Version", client.daemonVersion));
    dataList.add(
      KeyValueModel(
        "Vendor",
        device.vendor,
      ),
    );
    dataList.add(
      KeyValueModel(
        "Model",
        device.model,
      ),
    );
    dataList.add(
      KeyValueModel(
        "Technology",
        device.technology.name,
      ),
    );
    dataList.add(
      KeyValueModel(
        "Name",
        device.nativePath,
      ),
    );
    dataList.add(
      KeyValueModel(
        "Capacity",
        '${device.capacity.toStringAsFixed(2)}%',
      ),
    );
    var batteryState = '';
    switch (device.state) {
      case UPowerDeviceState.charging:
        batteryState = "Charging";
        break;
      case UPowerDeviceState.discharging:
        batteryState = "Discharging";
        break;
      case UPowerDeviceState.fullyCharged:
        batteryState = "Full Charged";
        break;
      case UPowerDeviceState.pendingCharge:
        batteryState = "Pending Charge";
      case UPowerDeviceState.pendingDischarge:
        batteryState = "Pending Discharge";
        break;
      default:
        batteryState = "Unknown";
        break;
    }
    dataList.add(KeyValueModel("Battery State", batteryState));
    dataList.add(
      KeyValueModel(
        "Designed Capacity",
        '${device.energyFullDesign.toStringAsFixed(2)}Whr',
      ),
    );
    dataList.add(
      KeyValueModel(
        "Empty Capacity",
        '${device.energyEmpty}Whr',
      ),
    );
    dataList.add(
      KeyValueModel(
        "Current Max Capacity",
        '${device.energyFull.toStringAsFixed(2)}Whr',
      ),
    );
    dataList.add(
      KeyValueModel(
        "Current Capacity",
        '${device.energy.toStringAsFixed(2)}Whr',
      ),
    );

    var stateSign = batteryState == "Charging"
        ? "+"
        : batteryState == "Discharging"
            ? "-"
            : "";
    dataList.add(
      KeyValueModel(
        "Energy Rate",
        '${stateSign + device.energyRate.toStringAsFixed(2)}Whr',
      ),
    );
    dataList.add(
      KeyValueModel(
        "Voltage",
        device.voltage.toString(),
      ),
    );
    dataList.add(
      KeyValueModel(
        "Current Charging",
        '${device.percentage}%',
      ),
    );

    // List<UPowerDeviceStatisticsRecord> x =
    //     await device.getStatistics("charging");
    // print(x);
    client.close();
    setState(() {});
  }

  @override
  void initState() {
    getBattery();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: dataList
            .map(
              (item) => KeyValueWidget(label: item.key, value: item.value),
            )
            .toList(),
      ),
    );
  }
}

class KeyValueWidget extends StatelessWidget {
  const KeyValueWidget({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 46, 46, 46),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(value),
        ],
      ),
    );
  }
}
