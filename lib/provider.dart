import 'package:flutter/material.dart';
import 'package:upower/upower.dart';

class RootProvider extends ChangeNotifier {
  late UPowerDevice _selectedBattery;

  void setSelectedBattery(UPowerDevice device) {
    _selectedBattery = device;
    notifyListeners();
  }

  UPowerDevice getSelectedBattery() {
    return _selectedBattery;
  }
}
