import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:parking_app/constants.dart';
import 'package:parking_app/services/notification_service.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart'; // Ensure Polygon is imported from here
import 'polygon_helper.dart';
import 'dart:async';
import 'data_saver.dart';
import 'data_saver.dart';

class LocationProvider extends ChangeNotifier {
  Position _currentLocation = Position(
    longitude: 75.780411,
    latitude: 11.258753,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );
  bool _serviceEnabled = true;
  Location location = Location();
  List<Polygon> polygons = PolygonHelper.createPolygons();

  DateTime? _stopTime;
  Timer? _stopTimer;
  bool _isInsidePolygon = false;
  bool _notificationShown = false; // Flag to track if notification has been shown
  final GlobalKey<NavigatorState> navigatorKey;
    final DataSaver _dataSaver = DataSaver(); // Initialize your DataSaver instance
    bool _insidePolygonConfirmed = false; // Declare and initialize the flag



  LocationProvider(this.navigatorKey) {
    _startLocationUpdates();
  }

  bool get serviceEnabled => _serviceEnabled;

  Future<void> determinePosition() async {
    // Your existing code
  }

  void _startLocationUpdates() {
    location.onLocationChanged.listen((LocationData locationData) {
      _currentLocation = Position(
        longitude: locationData.longitude!,
        latitude: locationData.latitude!,
        timestamp: DateTime.now(),
        accuracy: locationData.accuracy ?? 5,
        altitude: locationData.altitude ?? 0,
        altitudeAccuracy: 0,
        heading: locationData.heading ?? 0,
        headingAccuracy: 0,
        speed: locationData.speed ?? 0,
        speedAccuracy: locationData.speedAccuracy ?? 1,
      );
      _checkIfInsidePolygons();
      _monitorSpeedAndStop();
      notifyListeners();
    });
  }

  void _checkIfInsidePolygons() {
    LatLng currentLatLng = LatLng(_currentLocation.latitude, _currentLocation.longitude);
    _isInsidePolygon = false;

    for (Polygon polygon in polygons) {
      if (PolygonHelper.isPointInPolygon(currentLatLng, polygon.points)) {
        _isInsidePolygon = true;
        break;
      }
    }
    print(_isInsidePolygon ? 'Inside a polygon' : 'Outside all polygons');
    if (!_isInsidePolygon) {
      _notificationShown = false; // Reset notification flag when outside all polygons
    }
  }

  // void _monitorSpeedAndStop() {
  //   double speed = _currentLocation.speed;
  //   print('Current speed: $speed');

  //   const double speedThreshold = 5.0; // Speed threshold in m/s
  //   const Duration stopDuration = Duration(seconds: 30); // Stop duration before showing notification

  //   if (speed > speedThreshold) {
  //     print('Speed above threshold, resetting stop timer.');
  //     _stopTime = null;
  //     _stopTimer?.cancel();
  //     _stopTimer = null;
  //     _notificationShown = false; // Reset notification flag when the user moves
  //   } else if (_isInsidePolygon && !_notificationShown) {
  //     if (_stopTime == null) {
  //       _stopTime = DateTime.now();
  //       print('Stop time set to $_stopTime');
  //     }

  //     _stopTimer?.cancel();

  //     _stopTimer = Timer.periodic(Duration(seconds: 1), (timer) {
  //       if (_stopTime != null) {
  //         final elapsedTime = DateTime.now().difference(_stopTime!);
  //         print('Elapsed time: $elapsedTime');

  //         if (elapsedTime >= stopDuration) {
  //           print('User has been stationary inside a polygon for more than $stopDuration');

  //           WidgetsBinding.instance.addPostFrameCallback((_) {
  //             if (navigatorKey.currentState?.overlay != null) {
  //               NotificationService.showPolygonNotification(
  //                 navigatorKey.currentState!.context,
  //                 onYesPressed: () {
  //                   print('User confirmed they are inside the polygon.');
  //                   // Add logic to handle 'Yes' response
  //                   _notificationShown = true; // Mark the notification as shown
  //                 },
  //                 onNoPressed: () {
  //                   print('User confirmed they are not inside the polygon.');
  //                   // Add logic to handle 'No' response
  //                   _notificationShown = true; // Mark the notification as shown
  //                 },
  //               );
  //             }
  //           });

  //           timer.cancel(); // Stop the periodic timer after sending the notification
  //           _stopTime = null; // Reset stop time to avoid multiple notifications
  //         }
  //       } else {
  //         timer.cancel(); // Cancel timer if stopTime is null
  //       }
  //     });
  //   } else {
  //     print('Outside polygon or moving, stop timer not started.');
  //     _stopTime = null;
  //     _stopTimer?.cancel();
  //     _stopTimer = null;
  //   }
  // }


  // void _monitorSpeedAndStop() {
  //   double speed = _currentLocation.speed;
  //   print('Current speed: $speed');

  //   const double speedThreshold = 5.0; // Speed threshold in m/s
  //   const Duration stopDuration = Duration(seconds: 30); // Stop duration before showing notification

  //   if (speed > speedThreshold) {
  //     print('Speed above threshold, resetting stop timer.');
  //     _stopTime = null;
  //     _stopTimer?.cancel();
  //     _stopTimer = null;
  //     _notificationShown = false; // Reset notification flag when the user moves
  //   } else if (_isInsidePolygon && !_notificationShown) {
  //     if (_stopTime == null) {
  //       _stopTime = DateTime.now();
  //       print('Stop time set to $_stopTime');
  //     }

  //     _stopTimer?.cancel();

  //     _stopTimer = Timer.periodic(Duration(seconds: 1), (timer) {
  //       if (_stopTime != null) {
  //         final elapsedTime = DateTime.now().difference(_stopTime!);
  //         print('Elapsed time: $elapsedTime');

  //         if (elapsedTime >= stopDuration) {
  //           print('User has been stationary inside a polygon for more than $stopDuration');

  //           WidgetsBinding.instance.addPostFrameCallback((_) {
  //             if (navigatorKey.currentState?.overlay != null) {
  //               NotificationService.showPolygonNotification(
  //                 navigatorKey.currentState!.context,
  //                 onYesPressed: () {
  //                   print('User confirmed they are inside the polygon.');

  //                   // Save the user's response, location, speed, and stop duration
  //                   _dataSaver.saveData(
  //                     response: 'Yes',
  //                     location: _currentLocation,
  //                     speed: speed,
  //                     stopDuration: elapsedTime,
  //                   );

  //                   _notificationShown = true; // Mark the notification as shown
  //                 },
  //                 onNoPressed: () {
  //                   print('User confirmed they are not inside the polygon.');

  //                   // Save the user's response, location, and speed
  //                   _dataSaver.saveData(
  //                     response: 'No',
  //                     location: _currentLocation,
  //                     speed: speed,
  //                   );

  //                   _notificationShown = true; // Mark the notification as shown
  //                 },
  //               );
  //             }
  //           });

  //           timer.cancel(); // Stop the periodic timer after sending the notification
  //           _stopTime = null; // Reset stop time to avoid multiple notifications
  //         }
  //       } else {
  //         timer.cancel(); // Cancel timer if stopTime is null
  //       }
  //     });
  //   } else {
  //     print('Outside polygon or moving, stop timer not started.');
  //     _stopTime = null;
  //     _stopTimer?.cancel();
  //     _stopTimer = null;
  //   }
  // }


void _monitorSpeedAndStop() {
  double speed = _currentLocation.speed;
  //print('Current speed: $speed');

  const double speedThreshold = 5.0; // Speed threshold in m/s
  const Duration stopDuration = Duration(seconds: 20); // Stop duration before showing notification

  if (speed > speedThreshold) {
    //print('Speed above threshold, resetting stop timer.');
    _stopTime = null;
    _stopTimer?.cancel();
    _stopTimer = null;
    _notificationShown = false; // Reset notification flag when the user moves
  } else if (_isInsidePolygon && !_notificationShown) {
    if (_stopTime == null) {
      _stopTime = DateTime.now();
      //print('Stop time set to $_stopTime');
    }

    _stopTimer?.cancel();

    _stopTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_stopTime != null) {
        final elapsedTime = DateTime.now().difference(_stopTime!);
        //print('Elapsed time: $elapsedTime');

        if (elapsedTime >= stopDuration) {
          //print('User has been stationary inside a polygon for more than $stopDuration');

          // Set notificationShown to true to avoid multiple triggers
          _notificationShown = true;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (navigatorKey.currentState?.overlay != null) {
              // Convert Position to LatLng
              LatLng currentLatLng = LatLng(_currentLocation.latitude, _currentLocation.longitude);

              // Get the current polygon name
              String? currentPolygonName = PolygonHelper.getPolygonName(currentLatLng);

              NotificationService.showPolygonNotification(
                navigatorKey.currentState!.context,
                onYesPressed: () {
                  //print('User confirmed they are inside the polygon.');

                  // Save the user's response, location, speed, stop duration, and polygon name
                  _dataSaver.saveData(
                    response: 'Yes',
                    location: _currentLocation,
                    speed: speed,
                    stopDuration: elapsedTime,
                    polygonName: currentPolygonName, // Include the current polygon name
                  );
                },
                onNoPressed: () {
                  //print('User confirmed they are not inside the polygon.');

                  // Save the user's response, location, speed, and polygon name
                  _dataSaver.saveData(
                    response: 'No',
                    location: _currentLocation,
                    speed: speed,
                    polygonName: currentPolygonName, // Include the current polygon name
                  );
                },
              );
            }
          });

          timer.cancel(); // Stop the periodic timer after sending the notification
          _stopTime = null; // Reset stop time to avoid multiple notifications
        }
      } else {
        timer.cancel(); // Cancel timer if stopTime is null
      }
    });
  } else {
    //print('Outside polygon or moving, stop timer not started.');
    _stopTime = null;
    _stopTimer?.cancel();
    _stopTimer = null;
  }
}





  Position get currentLocation => _currentLocation;

  @override
  void dispose() {
    _stopTimer?.cancel();
    super.dispose();
  }
}

