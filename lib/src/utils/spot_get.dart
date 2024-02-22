import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class SpotGet {
  SpotGet({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
  late GoogleMapController mapController;
  late LocationData currentLocation;
  late Location location;

  double Nowlatitude = 0;
  double Nowlongitude = 0;
  void getNowLocation() async {
    location = Location();
    currentLocation = await location.getLocation();
  }

  double distanceBetween(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  bool isNear(double lat1, double lon1, double lat2, double lon2) {
    return distanceBetween(lat1, lon1, lat2, lon2) < 10;
  }
}
