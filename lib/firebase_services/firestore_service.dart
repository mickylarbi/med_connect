import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_connect/firebase_services/auth_service.dart';
import 'package:med_connect/models/doctor.dart';
import 'package:med_connect/models/doctor_appointment.dart';
import 'package:med_connect/models/patient.dart';
import 'package:med_connect/utils/dialogs.dart';

class FirestoreService {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore instance = FirebaseFirestore.instance;

  // PATIENT

  DocumentReference<Map<String, dynamic>> get patientDocument =>
      instance.collection('patients').doc(auth.currentUser!.uid);

  Future<void> addPatient(Patient patient) =>
      patientDocument.set(patient.toFirestore());

  Future<void> updatePatient(Patient patient) =>
      patientDocument.update(patient.toFirestore());

  Future<void> deletePatient() => patientDocument.delete();

  // ADMIN

  CollectionReference<Map<String, dynamic>> get adminsCollection =>
      instance.collection('admins');

  // DOCTOR

  Query<Map<String, dynamic>> get doctorsCollection =>
      instance.collection('admins').where('adminRole', isEqualTo: 'doctor');

  Future<DocumentSnapshot<Map<String, dynamic>>> doctor(String id) =>
      adminsCollection.doc(id).get();

  // APPOINTMENT

  CollectionReference<Map<String, dynamic>> get appointmentsCollection =>
      instance.collection('doctor_appointments');

  Query<Map<String, dynamic>> get appointmentsList => appointmentsCollection
      .where('patientId', isEqualTo: auth.currentUser!.uid);
      
       Query<Map<String, dynamic>> get myAppointments => appointmentsCollection
      .where('patientId', isEqualTo: auth.currentUser!.uid);

  Future<DocumentReference<Map<String, dynamic>>> addAppointment(
          DoctorAppointment appointment) =>
      appointmentsCollection.add(appointment.toMap());

  Future<void> updateAppointment(DoctorAppointment appointment) =>
      appointmentsCollection.doc(appointment.id).update(appointment.toMap());

  Future<void> deleteAppointment(String appointmentId) =>
      appointmentsCollection.doc(appointmentId).delete();
}
