import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseWorkersAPI {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getWorkers() {
    return _firestore
        .collection('users')
        .where("type", isEqualTo: "worker")
        .snapshots();
  }

  Future<void> createWorker(
      String birthDay, String email, String name, String phone) async {
    DocumentReference newPost = _firestore.collection('users').doc(email);
    try {
      return newPost.set({
        'uid': newPost.id,
        'name': name,
        'phone': phone,
        'birthDay': birthDay,
        'email': email,
        'services': [],
        'photoURL': null,
        'token': "",
        'type': 'worker'
      });
    } catch (e) {
      return;
    }
  }

  Future<void> deleteWorker(String uid) async {
    return _firestore.collection('users').doc(uid).delete();
  }

  Stream<QuerySnapshot> getAppointments(String workerUid, int limit) {
    return _firestore
        .collection('appointments')
        .where('workerUid', isEqualTo: workerUid)
        .orderBy("sort", descending: true)
        .limit(limit)
        .snapshots();
  }

  Future<void> updateDataUser(value) {
    return _firestore.collection("users").doc(value["uid"]).update(value);
  }

  Future<List<dynamic>> getServices() async {
    QuerySnapshot qs = await _firestore.collection('services').get();
    return qs.docs
        .map((e) => {
              'cost': e.data().toString().contains('cost') ? e.get('cost') : 0,
              'duration': e.data().toString().contains('duration')
                  ? e.get('duration')
                  : 0,
              'durationHour': e.data().toString().contains('durationHour')
                  ? e.get('durationHour')
                  : 0,
              'durationMinutes': e.data().toString().contains('durationMinutes')
                  ? e.get('durationMinutes')
                  : 0,
              'name': e.data().toString().contains('name') ? e.get('name') : '',
              'uid': e.data().toString().contains('uid') ? e.get('uid') : ''
            })
        .toList();
  }
}
