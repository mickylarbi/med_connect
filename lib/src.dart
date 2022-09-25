import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:med_connect/sandbox.dart';
import 'package:med_connect/screens/home/tab_view.dart';
import 'package:med_connect/screens/splash_screen.dart';

class Src extends StatelessWidget {
  const Src({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      theme: ThemeData(
          primaryColor: Colors.blueGrey,
          primarySwatch: Colors.blueGrey,
          iconTheme: const IconThemeData(color: Colors.blueGrey),
          textTheme: GoogleFonts.openSansTextTheme(
            const TextTheme(
              bodyText2: TextStyle(color: Colors.blueGrey, letterSpacing: .2),
            ),
          ),
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.grey[50],
            
          )),
    );
  }
}
