import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

late GoogleMapController _mapController;
LatLng selectedPosition = LatLng(6.6745, -1.5716);
late AnimationController lifter;

onMapCreated(GoogleMapController controller) {
  _mapController = controller;
  try {
    getCurrentLocation();
  } catch (e) {
    log(e.toString());
  }
}

getCurrentLocation() async {
  bool? serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    // return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  Position pos = await Geolocator.getCurrentPosition();
  LatLng currentPos = LatLng(pos.latitude, pos.longitude);
  selectedPosition = currentPos;
  _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: currentPos, zoom: 18)));
}

onCameraIdle() {
  lifter.reverse();
}

onCameraMove(CameraPosition pos) {
  lifter.forward();
  selectedPosition = pos.target;
}

disposeMapController() {
  _mapController.dispose();
}
