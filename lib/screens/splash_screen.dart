import 'package:flutter/material.dart';
import 'package:med_connect/app_resources.dart';
import 'package:med_connect/screens/auth/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      opacity = 1;
      setState(() {});
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AuthWidget()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: AnimatedOpacity(
        duration: const Duration(seconds: 2),
        opacity: opacity,
        child: Hero(//TODO: work on hero animation
          tag: kLogoTag,
          child: Image.asset(
            'assets/images/logo.png',
            width: kScreenWidth(context) - 48,
          ),
        ),
      )),
    );
  }
}
