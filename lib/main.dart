import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/firebase_options.dart';
import 'package:med_connect/src.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Src());

//? NHIS things
}
