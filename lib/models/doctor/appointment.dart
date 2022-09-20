import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:med_connect/utils/constants.dart';

class Appointment {
  String? id;
  String? doctorId;
  String? doctorName;
  String? patientId;
  String? patientName;
  String? service;
  DateTime? dateTime;
  List<String>? symptoms;
  List<String>? conditions;
  bool? isConfirmed;
  String? venueString;
  LatLng? venueGeo;

  Appointment({
    this.id,
    this.doctorId,
    this.doctorName,
    this.patientId,
    this.patientName,
    this.dateTime,
    this.service,
    this.conditions,
    this.symptoms,
    this.isConfirmed,
    this.venueString,
    this.venueGeo,
  });

  Appointment.fromFirestore(Map<String, dynamic> map, String aId) {
    id = aId;
    doctorId = map['doctorId'] as String?;
    doctorName = map['doctorName'] as String?;
    patientId = map['patientId'] as String?;
    patientName = map['patientName'] as String?;
    service = map['service'] as String?;

    dateTime = DateTime.fromMillisecondsSinceEpoch(
        (map['dateTime'] as Timestamp).millisecondsSinceEpoch);

    symptoms = map['symptoms'] == null
        ? null
        : (map['symptoms'] as List<dynamic>?)!
            .map((e) => e.toString())
            .toList();

    conditions = map['conditions'] == null
        ? null
        : (map['conditions'] as List<dynamic>?)!
            .map((e) => e.toString())
            .toList();

    isConfirmed = map['isConfirmed'] as bool?;

    venueString = map['venueString'] as String?;

    venueGeo = LatLng(map['venueGeo']['lat'], map['venueGeo']['lng']);
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'patientId': FirebaseAuth.instance.currentUser!.uid,
      'patientName': kpatientName,
      'service': service,
      'dateTime': dateTime,
      'symptoms': symptoms ?? [],
      'conditions': conditions ?? [],
      'venueString': venueString,
      'venueGeo': {'lat': venueGeo!.latitude, 'lng': venueGeo!.longitude},
      'isConfirmed': false,
    };
  }

  @override
  bool operator ==(other) =>
      other is Appointment &&
      patientId == other.patientId &&
      patientName == other.patientName &&
      doctorId == other.doctorId &&
      dateTime == other.dateTime &&
      service == other.service &&
      symptoms == other.symptoms &&
      conditions == other.conditions &&
      other.isConfirmed == isConfirmed &&
      other.venueString == venueString &&
      other.venueGeo == venueGeo;

  @override
  int get hashCode => hashValues(
        patientId,
        patientName,
        doctorId,
        dateTime,
        service,
        hashList(symptoms),
        hashList(conditions),
        isConfirmed,
        venueString,
        venueGeo,
      );
}
