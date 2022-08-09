import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> profileImageUrl(String doctorId) =>
      storage.ref().child('profile_pictures/$doctorId').getDownloadURL();
}
