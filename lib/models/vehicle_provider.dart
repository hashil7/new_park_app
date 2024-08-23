import 'package:flutter/material.dart';

class VehicleProvider with ChangeNotifier {
  String _selectedVehicle = 'bike';
  bool _isCar = true;

  String get selectedVehicle => _selectedVehicle;
  bool get isCar => _isCar;

  void selectVehicle(String vehicle) {
    _selectedVehicle = vehicle;
    _isCar = vehicle == 'car';
    notifyListeners();
  }
}
