import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

enum LocationPermissionStatus { granted, denied, permanentlyDenied, restricted }

class _MapPageState extends State<MapPage> {
  late LatLng _myPosition = const LatLng(0, 0);
  CameraPosition _cameraPosition =
      const CameraPosition(target: LatLng(0, 0), zoom: 16, bearing: 0.0);
  late GoogleMapController mapController;
  Location location = Location();
  StreamSubscription? _locationChangedListen;
  List<dynamic> _spots = [];
  Set<Marker> markers = Set();

  void showCurrentLocation() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_myPosition.latitude, _myPosition.longitude),
        zoom: 16.0,
        bearing: _cameraPosition.bearing)));
  }

  void resetBearing() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0.0,
        target: _cameraPosition.target,
        zoom: _cameraPosition.zoom)));
  }

  Future<bool> get isGranted async {
    final status = await permission.Permission.location.status;
    switch (status) {
      case permission.PermissionStatus.granted:
      case permission.PermissionStatus.limited:
        return true;
      case permission.PermissionStatus.denied:
      case permission.PermissionStatus.permanentlyDenied:
      case permission.PermissionStatus.restricted:
        return false;
      default:
        return false;
    }
  }

  Future<bool> get isAlwaysGranted {
    return permission.Permission.locationAlways.isGranted;
  }

  Future<LocationPermissionStatus> whileRequest() async {
    final status = await permission.Permission.location.request();
    switch (status) {
      case permission.PermissionStatus.granted:
        return LocationPermissionStatus.granted;
      case permission.PermissionStatus.denied:
        return LocationPermissionStatus.denied;
      case permission.PermissionStatus.limited:
      case permission.PermissionStatus.permanentlyDenied:
        return LocationPermissionStatus.permanentlyDenied;
      case permission.PermissionStatus.restricted:
        return LocationPermissionStatus.restricted;
      default:
        return LocationPermissionStatus.denied;
    }
  }

  Future<LocationPermissionStatus> alwaysRequest() async {
    final status = await permission.Permission.locationAlways.request();
    switch (status) {
      case permission.PermissionStatus.granted:
        return LocationPermissionStatus.granted;
      default:
        return LocationPermissionStatus.denied;
    }
  }

  Future<void> update() async {
    await location.enableBackgroundMode(enable: true);
    _locationChangedListen = location.onLocationChanged.listen((event) async {
      setState(() {
        _myPosition = LatLng(event.latitude!, event.longitude!);
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      // 自分の座標を取得
      LocationData currentLocation = await location.getLocation();
      setState(() {
        _myPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _cameraPosition = CameraPosition(target: _myPosition);
        _getSpots(20);
      });
      showCurrentLocation();
    } catch (e) {
      log('Could not get the location: $e');
    }
  }

  Future<void> _showSpots() async {
    for (Map<String, dynamic> spot in _spots) {
      Marker spotMarker = Marker(
          markerId: MarkerId(spot["place_id"]),
          position: LatLng(spot["geometry"]["location"]["lat"],
              spot["geometry"]["location"]["lng"]),
          onTap: () {
            debugPrint("MARKER TAPPED!!!");
          },
          flat: true);
      markers.add(spotMarker);
    }
  }

  Future<void> _getSpots(int min) async {
    String? mapsApiKey = dotenv.env["MAPS_API"];
    String nextPageToken = "";
    for (int i = 0; i < min; i += 20) {
      if (nextPageToken != "") {
        await Future.delayed(const Duration(seconds: 2));
        final spotsRes = await http.get(Uri.parse(
            'https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=$nextPageToken&key=$mapsApiKey'));
        if (spotsRes.statusCode == 200) {
          Map<String, dynamic> spotsData = jsonDecode(spotsRes.body);
          if (spotsData["status"] != "ZERO_RESULTS") {
            List<dynamic> spots = spotsData["results"];
            _spots += spots;
            if (spotsData.containsKey("next_page_token")) {
              nextPageToken = spotsData["next_page_token"];
            } else {
              break;
            }
          } else {
            break;
          }
        } else {
          // show toast
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("スポットの取得に失敗しました")));
          break;
        }
      } else {
        final spotsRes = await http.get(Uri.parse(
            'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_myPosition.latitude},${_myPosition.longitude}&radius=1500&language=ja&key=$mapsApiKey'));
        if (spotsRes.statusCode == 200) {
          Map<String, dynamic> spotsData = jsonDecode(spotsRes.body);
          if (spotsData["status"] != "ZERO_RESULTS") {
            List<dynamic> spots = spotsData["results"];
            _spots += spots;
            if (spotsData.containsKey("next_page_token")) {
              nextPageToken = spotsData["next_page_token"];
            } else {
              break;
            }
          } else {
            break;
          }
        } else {
          // show toast
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("スポットの取得に失敗しました")));
          break;
        }
      }
    }
    _showSpots();
  }

  @override
  void initState() {
    super.initState();
    whileRequest().then((value) {
      if (value == LocationPermissionStatus.granted) {
        alwaysRequest();
        _getCurrentLocation();
        update();
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("位置情報の許可が必要です"),
                  content: const Text("設定画面から位置情報の許可をしてください"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"))
                  ],
                ));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _locationChangedListen?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _myPosition,
          zoom: 16.0,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        onCameraMove: (position) {
          setState(() {
            _cameraPosition = position;
          });
        },
        markers: markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'bearing',
            child: Transform.rotate(
                angle: -_cameraPosition.bearing / 50,
                child: const Icon(
                  Icons.explore_outlined,
                )),
            onPressed: () {
              resetBearing();
            },
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'current',
            child: const Icon(
              Icons.my_location,
            ),
            onPressed: () {
              showCurrentLocation();
            },
          ),
        ],
      ),
    );
  }
}
