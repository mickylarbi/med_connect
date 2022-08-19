import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:med_connect/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect/utils/map_functions.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  // late final GoogleMapController _controller;

  @override
  void initState() {
    super.initState();

    lifter = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    lifter.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          googleMap(),
          Center(
            child: Transform.translate(
              offset: Offset(.0, -20 + (lifter.value * -15)),
              child: SizedBox(
                height: 40,
                width: 40,
                child: Image.asset('assets/images/location_pin.png'),
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: lifter,
              child: const CircleAvatar(
                radius: 2,
                backgroundColor: Colors.grey,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: FloatingActionButton(
                onPressed: () {
                  getCurrentLocation();
                },
                child: const Icon(Icons.my_location),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 88,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: SolidIconButton(
                  onPressed: () {
                    // Navigator.pop(context);

                    log(Colors.blueGrey.toString());
                  },
                  iconData: Icons.arrow_back,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GoogleMap googleMap() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(
        target: selectedPosition,
        zoom: 14.4746,
      ),
      onMapCreated: onMapCreated,
      onCameraIdle: onCameraIdle,
      onCameraMove: onCameraMove,
      onCameraMoveStarted: onCameraMoveStarted,
    );
  }

  @override
  void dispose() {
    disposeMapController();
    lifter.dispose();

    super.dispose();
  }
}
