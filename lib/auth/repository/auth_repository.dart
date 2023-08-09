import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bequeen/auth/repository/auth_firebase_api.dart';

class AuthRepository {
  final _firebaseAuthAPI = FirebaseAuthAPI();

  Future<void> createUserFirestore(
          String birthDay, String email, String name, String phone) =>
      _firebaseAuthAPI.createUserFirestore(birthDay, email, name, phone);

  Stream<User?> get onAuthStateChanged => _firebaseAuthAPI.onAuthStateChanged;

  Future<void> updateDataUser(User user, value) =>
      _firebaseAuthAPI.updateDataUser(user, value);

  Future<void> updateUserToken(String token, value) =>
      _firebaseAuthAPI.updateUserToken(token, value);

  Future<DocumentSnapshot> getDataUser(String userId) =>
      _firebaseAuthAPI.getDataUser(userId);

  Future<UserCredential> signInWithEmailAndPassword(
          String email, String password) =>
      _firebaseAuthAPI.signInWithEmailAndPassword(email, password);

  Future<void> sendPasswordResetEmail(String email) =>
      _firebaseAuthAPI.sendPasswordResetEmail(email);

  Future<UserCredential> createUserWithEmailAndPassword(
          String email, String password) =>
      _firebaseAuthAPI.createUserWithEmailAndPassword(email, password);

  Future<void> signOut() => _firebaseAuthAPI.signOut();

  Future<void> deleteUser(String uid) => _firebaseAuthAPI.deleteUser(uid);
}
