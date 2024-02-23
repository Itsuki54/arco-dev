import 'dart:math';

import 'package:flutter/material.dart';

class SpotGet {
  double distanceBetween(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 100;
  }

  bool isNear(double lat1, double lon1, double lat2, double lon2) {
    debugPrint('Distance: ${distanceBetween(lat1, lon1, lat2, lon2)}');
    return distanceBetween(lat1, lon1, lat2, lon2) < 10;
  }
}
