import 'dart:typed_data';

import 'firebase_storage.dart';
import '../model/site.dart';
import '../services/auth.dart';
import 'firestore_backend.dart';
import 'storage.dart';

class MyController {
  static Storage storage = FirestoreBackend();
  static final _firebaseStorage = FirebaseStorage();

  static Future<List<Site>> getSites() {
    return storage.getSites();
  }

  static Future<void> deleteSite(Site site) {
    return storage.removeSite(site);
  }

  static Future<Site> addSite(String url, String username, String password) {
    return storage.insertSite(url, username, password);
  }

  static Future<String?> createAccount(
      {required String email, required String password}) {
    return Auth.createAccountWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<String?> signIn({required String email, required String password}) {
    return Auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static void signOut() {
    return Auth.signOut();
  }

  static String? getUserId() {
    return Auth.getUserId();
  }

  static bool isSignedIn() {
    return Auth.isSignedIn();
  }

  static Future<Uint8List?> getProfilePicture() {
    return _firebaseStorage.getProfilePicture();
  }

  static void setProfilePicture(Uint8List data) {
    return _firebaseStorage.setProfilePicture(data);
  }
}
