import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserFirestore(
      String birthDay, String email, String name, String phone) async {
    DocumentReference newPost = _firestore.collection('users').doc(email);
    try {
      return newPost.set({
        'uid': newPost.id,
        'name': name,
        'phone': phone,
        'birthDay': birthDay,
        'email': email,
        'photoURL': null,
        'accumulatedPoints': 0,
        'redeemedPoints': 0,
        'token': "",
        'type': 'client'
      });
    } catch (e) {
      return;
    }
  }

  Stream<User?> get onAuthStateChanged => _auth.authStateChanges();

  Future<DocumentSnapshot> getDataUser(String userId) {
    return _firestore.collection("users").doc(userId).get();
  }

  Future<void> updateDataUser(User user, value) {
    return _firestore.collection("users").doc(user.uid).update(value);
  }

  Future<void> updateUserToken(String token, value) async {
    DocumentReference updatePost =
        _firestore.collection('users').doc(value["uid"]);
    try {
      if (value["type"] == "worker") {
        return updatePost.update({
          'uid': value["uid"],
          'name': value["name"],
          'phone': value["phone"],
          'birthDay': value["birthDay"],
          'email': value["email"],
          'services': value["services"],
          'photoURL': value["photoURL"],
          'token': token,
          'type': value["type"]
        });
      } else {
        return updatePost.update({
          'uid': value["uid"],
          'name': value["name"],
          'phone': value["phone"],
          'birthDay': value["birthDay"],
          'email': value["email"],
          'photoURL': value["photoURL"],
          'accumulatedPoints': value["accumulatedPoints"],
          'redeemedPoints': value["redeemedPoints"],
          'token': token,
          'type': value["type"]
        });
      }
    } catch (e) {
      return;
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(email, password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    final res = await _auth.signOut();
    return res;
  }

  Future<void> deleteUser(String uid) async {
    return _firestore.collection('users').doc(uid).delete();
  }
}
