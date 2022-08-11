import 'package:flutter/material.dart';
import 'package:med_connect/firebase_services/auth_service.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';

class MorePage extends StatelessWidget {
  MorePage({Key? key}) : super(key: key);

  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: CustomFlatButton(
        onPressed: () {
          auth.signOut(context);
        },
        child: const Text('Sign out'),
      )),
    );
  }
}
