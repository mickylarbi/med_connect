import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String? id;
  String? location;
  String? doctorId;
  String? patientId;
  String? service;
  DateTime? dateTime;
  List<String>? symptoms;
  String? condition;

  Appointment(
      {this.id,
      this.location,
      this.doctorId,
      this.patientId,
      this.dateTime,
      this.service,
      this.condition,
      this.symptoms});

  Appointment.fromFirestore(Map<String, dynamic> map, String aId) {
    id = aId;
    location = map['location'] as String?;
    doctorId = map['doctorId'] as String?;
    patientId = map['patientId'] as String?;
    service = map['service'] as String?;
    dateTime = DateTime.fromMillisecondsSinceEpoch(
        (map['dateTime'] as Timestamp).millisecondsSinceEpoch);
    symptoms =
        (map['symptoms'] as List<dynamic>?)!.map((e) => e.toString()).toList();
    condition = map['condition'] as String?;
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'doctorId': doctorId,
      'patientId': patientId,
      'service': service,
      'dateTime': dateTime,
      'symptoms': symptoms,
      'condition': condition,
    };
  }
}
