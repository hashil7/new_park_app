// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'polygon_helper.dart';
// import 'package:parking_app/services/notification_service.dart';
// import 'dart:async';

// class SpeedMonitor {
//   static const double speedThreshold = 5.0; // Speed threshold in m/s (adjust as needed)
//   Timer? stopTimer;

//   void monitorSpeed(LocationData locationData, BuildContext context, bool isInsidePolygon) {
//     if (locationData.speed != null) {
//       double speed = locationData.speed!;

//       if (isInsidePolygon && speed < speedThreshold) {
//         // Start or continue the timer if below speed threshold
//         stopTimer ??= Timer(Duration(minutes: 1), () {
//           // Show notification after 1 minute of low speed
//           NotificationService.showPolygonNotification(context);
//         });
//       } else {
//         // Reset the timer if speed is above threshold or outside polygon
//         stopTimer?.cancel();
//         stopTimer = null;
//       }
//     }
//   }
// }