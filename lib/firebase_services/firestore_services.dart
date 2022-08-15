import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/firebase_services/auth_service.dart';
import 'package:med_connect/models/doctor.dart';
import 'package:med_connect/models/doctor_appointment.dart';
import 'package:med_connect/models/patient.dart';
import 'package:med_connect/utils/dialogs.dart';

class FirestoreServices {
  AuthService auth = AuthService();
  FirebaseFirestore instance = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> get patientDocument =>
      instance.collection('patients').doc(auth.uid);
  Future<DocumentSnapshot<Map<String, dynamic>>> get patient =>
      patientDocument.get();

  addPatient(Patient patient) async {
    await patientDocument.set(patient.toFirestore());
  }

  updatePatient(BuildContext context, Patient patient) async {
    //TODO:
    showLoadingDialog(context);
    patientDocument.update(patient.toFirestore()).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showAlertDialog(context);
    });
  }

  deletePatient() async {
    //TODO: implement this
    await patientDocument.delete();
  }

  CollectionReference<Map<String, dynamic>> get doctorsCollection =>
      instance.collection('doctors');

  //TODO: with converter things
  Future<QuerySnapshot<Map<String, dynamic>>> get doctorsList =>
      doctorsCollection.get();

  Future<DocumentSnapshot<Map<String, dynamic>>> doctor(String id) =>
      doctorsCollection.doc(id).get();

  //APPOINTMENT

  CollectionReference<Map<String, dynamic>> get appointmentsCollection =>
      instance.collection('appointments');

  Future<QuerySnapshot<Map<String, dynamic>>> get appointmentsList =>
      appointmentsCollection.where('patientId', isEqualTo: auth.uid).get();

  void addAppointment(
      BuildContext context, DoctorAppointment appointment) async {
    showLoadingDialog(context);

    appointmentsCollection.add(appointment.toMap()).then((value) {
      Navigator.pop(context);
      showAlertDialog(context, message: 'Appointment add successfully');
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showAlertDialog(context, message: error.toString());
    });
  }

  updateAppointment(BuildContext context, DoctorAppointment appointment) async {
    showLoadingDialog(context);

    await appointmentsCollection
        .doc(appointment.id)
        .update(appointment.toMap())
        .then((value) {
      Navigator.pop(context);
      Navigator.pop(context, true);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showAlertDialog(context, message: 'Couldn\'t update appointment');
    });
  }
}
