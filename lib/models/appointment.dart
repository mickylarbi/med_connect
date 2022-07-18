import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String? id;
  String? location;
  String? doctorId;
  DateTime? dateTime;

  Appointment(this.id, this.location, this.doctorId, this.dateTime);

  Appointment.fromFirestore(Map<String, dynamic> map, String aId) {
    id = aId;
    location = map['location'] as String?;
    doctorId = map['doctorId'] as String?;
    dateTime = DateTime.fromMillisecondsSinceEpoch(
        (map['dateTime'] as Timestamp).millisecondsSinceEpoch);
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'doctorId': doctorId,
      'dateTime': dateTime,
    };
  }
}
