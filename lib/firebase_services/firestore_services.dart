import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  //TODO: with converter things
  Future<QuerySnapshot<Map<String, dynamic>>> get doctorsList =>
      instance.collection('doctors').get();

}
