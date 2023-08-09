import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseClientsAPI {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getClients() {
    return _firestore
        .collection('users')
        .where("type", isEqualTo: "client")
        .orderBy("name", descending: false)
        .snapshots();
  }

  Future<void> createClient(String name, String email, String phone) async {
    DocumentReference newPost = _firestore.collection('users').doc();
    try {
      return newPost.set({
        'uid': newPost.id,
        'name': "$name (Admin)",
        'phone': phone,
        'birthDay': "",
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

  Future<void> deleteClient(String uid) async {
    return _firestore.collection('users').doc(uid).delete();
  }

  Stream<QuerySnapshot> getAppointments(String clientUid, int limit) {
    return _firestore
        .collection('appointments')
        .where('clientUid', isEqualTo: clientUid)
        .orderBy("sort", descending: true)
        .limit(limit)
        .snapshots();
  }

  Stream<QuerySnapshot> getRedeemedPoints(String clientUid) {
    return _firestore
        .collection('redeemedPoints')
        .where("clientUid", isEqualTo: clientUid)
        .orderBy("sort", descending: true)
        .limit(50)
        .snapshots();
  }

  Future<void> updateRedeemPoints(value) async {
    DocumentReference newUpdatePost =
        _firestore.collection('redeemedPoints').doc(value["uid"]);
    try {
      return newUpdatePost.update({
        'uid': value["uid"],
        'state': "Aprobado",
        'year': value["year"],
        'month': value["month"],
        'day': value["day"],
        'hour': value["hour"],
        'minutes': value["minutes"],
        'sort': value["sort"],
        'clientUid': value["clientUid"],
        'clientName': value["clientName"],
        'redeemedPoints': value["redeemedPoints"],
        'qty': value["qty"],
      });
    } catch (e) {
      return;
    }
  }
}
