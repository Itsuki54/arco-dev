import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:arco_dev/src/structs/nearbysearch.dart' as NearBy;
import '../../utils/spot_get.dart';

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
  List<NearBy.Place> _spots = [];
  Set<Marker> markers = Set();
  Map<String, BitmapDescriptor> _markerIcons = {};

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

  String _getSpotIcon(List<String> types) {
    if (types.contains("bank")) {
      return "bank";
    } else if (types.contains("court")) {
      return "court";
    } else if (types.contains("restaurant")) {
      return "fastfood";
    } else if (types.contains("fire_station")) {
      return "fire";
    } else if (types.contains("food")) {
      return "food";
    } else if (types.contains("local_government_office")) {
      return "gov";
    } else if (types.contains("hospital")) {
      return "hospital";
    } else if (types.contains("lodging")) {
      return "hotel";
    } else if (types.contains("mountain")) {
      return "mountain";
    } else if (types.contains("park")) {
      return "park";
    } else if (types.contains("police")) {
      return "police";
    } else {
      return "food";
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> _setMarkerIcons() async {
    List icons = [
      "bank",
      "bowl",
      "court",
      "fastfood",
      "fire",
      "food",
      "gov",
      "hospital",
      "hotel",
      "mountain",
      "park",
      "police"
    ];
    for (String icon in icons) {
      Uint8List iconBytes =
          await getBytesFromAsset('assets/markers/icon-$icon.png', 100);
      _markerIcons[icon] = BitmapDescriptor.fromBytes(iconBytes);
    }
  }

  Future<void> _showSpots() async {
    await _setMarkerIcons();
    for (NearBy.Place spot in _spots) {
      debugPrint(spot.types!.join(","));
      Marker spotMarker = Marker(
          markerId: MarkerId(spot.placeId!),
          position:
              LatLng(spot.geometry!.location.lat, spot.geometry!.location.lng),
          icon: _markerIcons[_getSpotIcon(spot.types!)]!,
          onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                              height: 4,
                              width: 80,
                              child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(4)))),
                          const SizedBox(height: 12),
                          Text(spot.name!,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          Text(spot.vicinity!,
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 16),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white),
                                  onPressed: SpotGet().isNear(
                                    spot.geometry!.location.lat,
                                    spot.geometry!.location.lng,
                                    _myPosition.latitude,
                                    _myPosition.longitude,
                                  )
                                      ? () {
                                          Navigator.pop(context);
                                        }
                                      : null,
                                  child: const Text("閉じる")))
                        ],
                      ));
                });
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
          NearBy.PlacesNearbySearchResponse spotsData =
              NearBy.PlacesNearbySearchResponse.fromJson(
                  jsonDecode(spotsRes.body));
          if (spotsData.status != "ZERO_RESULTS") {
            List<NearBy.Place> spots = spotsData.results;
            _spots += spots;
            if (spotsData.nextPageToken != null) {
              nextPageToken = spotsData.nextPageToken!;
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
          NearBy.PlacesNearbySearchResponse spotsData =
              NearBy.PlacesNearbySearchResponse.fromJson(
                  jsonDecode(spotsRes.body));
          if (spotsData.status != "ZERO_RESULTS") {
            List<NearBy.Place> spots = spotsData.results;
            _spots += spots;
            if (spotsData.nextPageToken != null) {
              nextPageToken = spotsData.nextPageToken!;
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
    _getCurrentLocation();
    update();
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
          const SizedBox(height: 16),
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
