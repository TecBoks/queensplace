import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServicesAPI {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getServices() {
    return _firestore.collection('services').snapshots();
  }

  Future<void> createService(String name, int duration, double cost) async {
    DocumentReference newPost = _firestore.collection('services').doc();
    try {
      return newPost.set({
        'uid': newPost.id,
        'name': name,
        'duration': duration,
        'cost': cost
      });
    } catch (e) {
      return;
    }
  }

  Future<void> deleteService(String uid) async {
    return _firestore.collection('services').doc(uid).delete();
  }
}
