import 'package:med_connect/models/experience.dart';
import 'package:med_connect/models/review.dart';

class Doctor {
  String? id;
  String? name;
  String? mainSpecialty;
  List<String>? otherSpecialties;
  List<Experience>? experiences;
  List<Review>? reviews;
  String? bio;
  String? currentLocation;

  Doctor({this.id, this.name, this.mainSpecialty, this.otherSpecialties,
      this.experiences, this.reviews, this.bio, this.currentLocation});

  Doctor.fromFireStore(Map<String, dynamic> map, String dId) {
    id = dId;
    name = map['name'] as String?;
    mainSpecialty = map['mainSpecialty'] as String?;
    otherSpecialties = map['otherSpecialties'] as List<String>?;
    experiences = map['experiences'] as List<Experience>?;
    reviews = map['reviews'] as List<Review>?;
    bio = map['bio'] as String?;
    currentLocation = map['currentLocation'] as String?;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mainSpecialty': mainSpecialty,
      'otherSpecialties': otherSpecialties,
      'experiences': experiences,
      'reviews': reviews,
      'bio': bio,
      'currentLocation': currentLocation,
    };
  }
}
