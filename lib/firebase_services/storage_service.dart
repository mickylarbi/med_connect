import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:med_connect/firebase_services/auth_service.dart';

class StorageService {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> profileImageUrl(String doctorId) =>
      storage.ref().child('profile_pictures/$doctorId').getDownloadURL();
}

class ProfileImageBloc {
  File? profileImageFIle;
  StorageService storage = StorageService();
  AuthService auth = AuthService();

  final StreamController _eventStreamController = StreamController();
  final StreamController _stateStreamController = StreamController();

  StreamSink get eventSink => _eventStreamController.sink;
  Stream get stateStream => _stateStreamController.stream;

  createInstance() {
    _eventStreamController.stream.listen(getProfileImageFIle);
  }

  getProfileImageFIle(dynamic event)async {
    
  }

  void dispose() {
    _eventStreamController.close();
    _stateStreamController.close();
  }
}
