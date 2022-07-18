import 'package:flutter/material.dart';
import 'package:med_connect/sandbox.dart';
import 'package:med_connect/screens/home/tab_view.dart';
import 'package:med_connect/screens/splash_screen.dart';

class Src extends StatelessWidget {
  const Src({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TabView(),
    );
  }
}
