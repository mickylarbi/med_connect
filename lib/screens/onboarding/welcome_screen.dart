import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/firebase_services/auth_service.dart';
import 'package:med_connect/screens/onboarding/patient_info_screen.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: do the page better
    return Scaffold(
      body: Center(
        child: CustomFlatButton(
          onPressed: () {
            AuthService auth = AuthService();
            auth.signOut(context);
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const PatientInfoScreen()),
            //     (route) => false);
          },
          child: const Text('Welcome'),
        ),
      ),
    );
  }
}
