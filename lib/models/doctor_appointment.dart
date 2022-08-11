import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorAppointment {
  String? id;
  String? location;
  String? doctorId;
  String? doctorName;
  String? patientId;
  String? service;
  DateTime? dateTime;
  List<String>? symptoms;
  List<String>? conditions;

  DoctorAppointment(
      {this.id,
      this.location,
      this.doctorId,
      this.doctorName,
      this.patientId,
      this.dateTime,
      this.service,
      this.conditions,
      this.symptoms});

  DoctorAppointment.fromFirestore(Map<String, dynamic> map, String aId) {
    id = aId;
    location = map['location'] as String?;
    doctorId = map['doctorId'] as String?;
    doctorName = map['doctorName'] as String?;
    patientId = map['patientId'] as String?;
    service = map['service'] as String?;

    dateTime = DateTime.fromMillisecondsSinceEpoch(
        (map['dateTime'] as Timestamp).millisecondsSinceEpoch);

    symptoms =
        (map['symptoms'] as List<dynamic>?)!.map((e) => e.toString()).toList();

    conditions = (map['conditions'] as List<dynamic>?)!
        .map((e) => e.toString())
        .toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'patientId': patientId,
      'service': service,
      'dateTime': dateTime,
      'symptoms': symptoms,
      'conditions': conditions,
    };
  }

  @override
  bool operator ==(other) =>
      other is DoctorAppointment &&
      patientId == other.patientId &&
      doctorId == other.doctorId &&
      dateTime == other.dateTime &&
      service == other.service &&
      symptoms == other.symptoms &&
      conditions == other.conditions &&
      other.location == other.location;

  @override
  int get hashCode => hashValues(
        patientId,
        doctorId,
        dateTime,
        service,
        hashList(symptoms),
        hashList(conditions),
        location,
      );
}
