import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  double? rating;
  String? userId;
  String? appointmentId;
  String? doctorId;
  String? comment;
  DateTime? dateTime;

  Review(
      {this.rating,
      this.userId,
      this.comment,
      this.dateTime,
      this.appointmentId,
      this.doctorId});

  Review.fromFirestore(
    Map<String, dynamic> map,
  ) {
    rating = map['rating'];
    userId = map['userId'];
    appointmentId = map['appointmentId'];
    doctorId = map['doctorId'];
    comment = map['comment'];
    dateTime = DateTime.fromMillisecondsSinceEpoch(
        (map['dateTime'] as Timestamp).millisecondsSinceEpoch);
  }

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'userId': userId,
      'appointmentId': appointmentId,
      'doctorId': doctorId,
      'comment': comment,
      'dateTime': dateTime
    };
  }
}
