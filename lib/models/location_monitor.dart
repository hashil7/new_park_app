// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'dart:async';
// import 'polygon_helper.dart';

// class LocationMonitor {
//   final Location location;
//   LocationData? currentLocation;
//   DateTime? stopTime;
//   Timer? stopTimer;
//   final List<Polygon> polygons;
//   final BuildContext context;
//   bool isInsidePolygon = false;
//   static const double speedThreshold = 10.0; // Speed threshold in m/s

//   LocationMonitor({
//     required this.context,
//     required this.polygons,
//     required this.location,
//   }) {
//     _startLocationUpdates();
//   }

//   void _startLocationUpdates() {
//     location.onLocationChanged.listen((LocationData locationData) {
//       currentLocation = locationData;
//       _checkIfInsidePolygons();
//       _monitorSpeedAndStop();
//     });
//   }

//   void _checkIfInsidePolygons() {
//     if (currentLocation != null) {
//       LatLng currentLatLng = LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
//       isInsidePolygon = false;

//       for (Polygon polygon in polygons) {
//         if (PolygonHelper.isPointInPolygon(currentLatLng, polygon.points)) {
//           isInsidePolygon = true;
//           break;
//         }
//       }
//       print(isInsidePolygon ? 'Inside a polygon' : 'Outside all polygons');
//       isInsidePolygon?_showOnScreenNotification():_showOnScreenNotification();

//     }
//   }

//   void _monitorSpeedAndStop() {
//     if (currentLocation != null) {
//       double speed = currentLocation!.speed ?? 0.0;
//       print('Current speed: $speed');
      
//       if (speed > speedThreshold) {
//         print('Speed above threshold, resetting stop timer.');
//         stopTime = null;
//         stopTimer?.cancel();
//         stopTimer = null;
//       } else if (isInsidePolygon) {
//         if (stopTime == null) {
//           stopTime = DateTime.now();
//           print('Stop time set to $stopTime');
//         }

//         stopTimer?.cancel();
//         stopTimer = Timer(Duration(seconds: 20), () {
//           if (stopTime != null && DateTime.now().difference(stopTime!) >= Duration(seconds: 20)) {
//             print('User has been stationary inside a polygon for more than 20 seconds');
//             _showOnScreenNotification();
//           }
//         });
//         print('Timer restarted: $stopTimer');
//       }
//     }
//   }

//   void _showOnScreenNotification() {
//     if (context.mounted) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Polygon Notification"),
//             content: Text("You have been inside the polygon and stationary for over 20 seconds. Are you inside the polygon?"),
//             actions: <Widget>[
//               TextButton(
//                 child: Text("Yes"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   // Handle Yes action
//                 },
//               ),
//               TextButton(
//                 child: Text("No"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   // Handle No action
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       print('Context is not mounted. Cannot show dialog.');
//     }
//   }

//   void dispose() {
//     stopTimer?.cancel();
//   }
// }
