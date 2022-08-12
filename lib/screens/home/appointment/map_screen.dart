import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:med_connect/screens/shared/custom_app_bar.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: const CameraPosition(
                target: LatLng(6.6745, -1.5716),
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 88,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  heroTag: 'back',
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(36),
                child: FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.my_location_rounded),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  
}
