import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/firebase_options.dart';
import 'package:med_connect/src.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Src());
//TODO: change font color to blue grey

  'AIzaSyB0A7Aytdk8Si52D78Z8UdmIAgOL_Bg2B4';
}

//TODO: change font color to blue grey
