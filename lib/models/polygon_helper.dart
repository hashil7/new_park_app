// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class PolygonHelper {
//   // Define your polygons here
//   static final List<List<LatLng>> _polygonPoints = [
//     [
//       LatLng(11.321699492577258, 75.93347316054869),
//       LatLng(11.321791340091805, 75.93357321748574),
//       LatLng(11.321567983584648, 75.9338414552319),
//       LatLng(11.321474048552945, 75.93372862506882),
//     ],
//     [
//       LatLng(11.321284090950146, 75.93380313555387),
//       LatLng(11.321373851151792, 75.93388190378091),
//       LatLng(11.321332102224295, 75.93391170797494),
//       LatLng(11.321263216480615, 75.93384571297389),
//     ],
//   ];

//   static List<Polygon> createPolygons() {
//     return _polygonPoints.map((points) => Polygon(
//       points: points,
//       borderColor: Colors.red,
//       borderStrokeWidth: 3,
//       color: Color.fromARGB(255, 234, 105, 105).withOpacity(0.2),
//     )).toList();
//   }

//   static bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
//     int n = polygon.length;
//     bool inside = false;

//     double px = point.latitude;
//     double py = point.longitude;

//     double p1x = polygon[0].latitude;
//     double p1y = polygon[0].longitude;
//     for (int i = 1; i <= n; i++) {
//       double p2x = polygon[i % n].latitude;
//       double p2y = polygon[i % n].longitude;
//       if (py > p1y && py <= p2y || py > p2y && py <= p1y) {
//         if (px <= (p2x - p1x) * (py - p1y) / (p2y - p1y) + p1x) {
//           inside = !inside;
//         }
//       }
//       p1x = p2x;
//       p1y = p2y;
//     }

//     return inside;
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PolygonData {
  final String name;
  final List<LatLng> points;

  PolygonData({required this.name, required this.points});
}

class PolygonHelper {
  // Define your polygons with names here
  static final List<PolygonData> _polygonDataList = [
    PolygonData(
      name: 'Rajpath Road',
      points: [
        LatLng(11.321459952396351, 75.93397610205649),
        LatLng(11.321202170069096, 75.93374144939757),
        LatLng(11.320956459976967, 75.93350534826284),
        LatLng(11.320575467621046, 75.93314825385761),
        LatLng(11.320301351124703, 75.93293170711016),
        LatLng(11.320042946521022, 75.9327136075093),
        LatLng(11.319990395613454, 75.93281862182197),
        LatLng(11.320347599569843, 75.93311990425035),
        LatLng(11.320665745065218, 75.93342987751976),
        LatLng(11.321026498906075, 75.93377461414524),
        LatLng(11.321306295862176, 75.93402592424816),
        LatLng(11.321392933444407, 75.93410341756362),
      ],
    ),
    // PolygonData(
    //   name: 'CCC',
    //   points: [
    //     LatLng(11.321459055935234, 75.93372890011145),
    //     LatLng(11.321575755567254, 75.9338810303001),
    //     LatLng(11.321812456848841, 75.9335591652047),
    //     LatLng(11.321671751110609, 75.93343444248022),
    //   ],
    // ),
    PolygonData(
      name: 'CS Dept.',
      points: [
        LatLng(11.322124957093873, 75.93408438540133),
        LatLng(11.32247355948798, 75.93445693782247),
        LatLng(11.322425548408633, 75.93449099975435),
        LatLng(11.32208529572251, 75.93411631845814),
      ]
    )
    // Add more polygons as needed
  ];

  static List<Polygon> createPolygons() {
    return _polygonDataList.map((polygonData) => Polygon(
      points: polygonData.points,
      borderColor: Colors.red,
      borderStrokeWidth: 3,
      color: Color.fromARGB(255, 234, 105, 105).withOpacity(0.2),
      label: polygonData.name, // You can store the name as a label or as metadata
    )).toList();
  }

  static bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int n = polygon.length;
    bool inside = false;

    double px = point.latitude;
    double py = point.longitude;

    double p1x = polygon[0].latitude;
    double p1y = polygon[0].longitude;
    for (int i = 1; i <= n; i++) {
      double p2x = polygon[i % n].latitude;
      double p2y = polygon[i % n].longitude;
      if (py > p1y && py <= p2y || py > p2y && py <= p1y) {
        if (px <= (p2x - p1x) * (py - p1y) / (p2y - p1y) + p1x) {
          inside = !inside;
        }
      }
      p1x = p2x;
      p1y = p2y;
    }

    return inside;
  }

  static String? getPolygonName(LatLng point) {
    for (PolygonData polygonData in _polygonDataList) {
      if (isPointInPolygon(point, polygonData.points)) {
        return polygonData.name;
      }
    }
    return null; // Return null if the point is not inside any polygon
  }
}
