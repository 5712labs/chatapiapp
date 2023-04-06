import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyLocationProvider with ChangeNotifier {
  // int _count = 0;
  // LatLng _myLocation = const LatLng(36.431280, 127.644891);
  LatLng _myLocation = const LatLng(0, 0);

  // int get count => _count;
  LatLng get myLocation => _myLocation;

  // void getMyLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.low);
  //   _myLocation = LatLng(position.latitude, position.longitude); // 내위치
  //   notifyListeners();
  // }

  getMyLatLng() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      _myLocation = LatLng(position.latitude, position.longitude); // 내위치
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }
}
