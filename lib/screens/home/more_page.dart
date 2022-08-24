import 'package:flutter/material.dart';
import 'package:med_connect/firebase_services/auth_service.dart';
import 'package:med_connect/firebase_services/firestore_service.dart';
import 'package:med_connect/models/patient.dart';
import 'package:med_connect/sandbox.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';
import 'package:med_connect/utils/dialogs.dart';

class MorePage extends StatelessWidget {
  MorePage({Key? key}) : super(key: key);

  AuthService auth = AuthService();
  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomFlatButton(
          onPressed: () {
            Patient patient = Patient(
              firstName: 'Erin',
              surname: 'Jackson',
              phone: '0244079774',
              dateOfBirth: DateTime.now(),
              gender: 'Male',
              height: 120,
              weight: 70,
              bloodType: 'A+',
            );

            showLoadingDialog(context);
            db.patientDocument.set(patient.toFirestore()).then((value) {
              Navigator.pop(context);
              showAlertDialog(context, message: 'Success');
            }).onError((error, stackTrace) {
              Navigator.pop(context);
              showAlertDialog(context, message: 'Failed\n${error.toString()}');
            });
          },
          child: const Text('upload'),
        ),
      ),
    );
  }
}
