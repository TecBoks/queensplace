import 'package:cloud_firestore/cloud_firestore.dart';

class LoyaltyPointsFirebaseAPI {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getClients(String phone) {
    return _firestore
        .collection('users')
        .where("type", isEqualTo: "client")
        .where("phone", isEqualTo: phone)
        .snapshots();
  }

  Future<List<dynamic>> getTempPoints(String uid) async {
    QuerySnapshot qs = await _firestore
        .collection('tempPoints')
        .where('clientUid', isEqualTo: uid)
        .get();
    return qs.docs
        .map((e) => {
              'appointmentUid': e.data().toString().contains('appointmentUid') ? e.get('appointmentUid') : '',
              'endDate': e.data().toString().contains('endDate') ? e.get('endDate') : 0,
              'points': e.data().toString().contains('points') ? e.get('points') : 0,
              'uid': e.data().toString().contains('uid') ? e.get('uid') : ''
            })
        .toList();
  }

  Future<void> deleteTempPoints(String uid) async {
    return _firestore.collection('tempPoints').doc(uid).delete();
  }

  Future<void> updateDataUser(String tempPointsUid, value) async {
    WriteBatch batch = _firestore.batch();
    DocumentReference updatePost =
        _firestore.collection('users').doc(value["uid"]);
    DocumentReference deletePost =
        _firestore.collection('tempPoints').doc(tempPointsUid);
    batch.set(updatePost, {
      'uid': value["uid"],
      'name': value["name"],
      'phone': value["phone"],
      'birthDay': value["birthDay"],
      'email': value["email"],
      'redeemedPoints': value["redeemedPoints"],
      'accumulatedPoints': value["accumulatedPoints"],
      'photoURL': value["photoURL"],
      'token': value["token"],
      'type': value["type"]
    });
    batch.delete(deletePost);
    try {
      return batch.commit();
    } catch (e) {
      return;
    }
  }

  Future<DocumentSnapshot> getDataUser(String userId) {
    return _firestore.collection("users").doc(userId).get();
  }

  Future<void> redeemPoints(
      String comment,
      String correlative,
      double redeemedPoints,
      double qty,
      int year,
      int month,
      int day,
      int hour,
      int minutes,
      int sort,
      value) async {
    WriteBatch batch = _firestore.batch();
    DocumentReference newSetPost =
        _firestore.collection('redeemedPoints').doc();
    DocumentReference newUpdatePost =
        _firestore.collection('users').doc(value["uid"]);
    batch.set(newSetPost, {
      'uid': newSetPost.id,
      'state': "Pendiente",
      'year': year,
      'month': month,
      'day': day,
      'hour': hour,
      'minutes': minutes,
      'sort': sort,
      'comment': comment,
      'correlative': correlative,
      'clientUid': value["uid"],
      'clientName': value["name"],
      'redeemedPoints': redeemedPoints,
      'qty': qty,
    });
    batch.update(newUpdatePost, {
      'uid': value["uid"],
      'name': value["name"],
      'phone': value["phone"],
      'birthDay': value["birthDay"],
      'email': value["email"],
      'redeemedPoints': value["redeemedPoints"],
      'accumulatedPoints': value["accumulatedPoints"],
      'photoURL': value["photoURL"],
      'token': value["token"],
      'type': value["type"]
    });
    try {
      return batch.commit();
    } catch (e) {
      return;
    }
  }

  Stream<QuerySnapshot> getRedeemedPoints(String clientUid) {
    return _firestore
        .collection('redeemedPoints')
        .where("clientUid", isEqualTo: clientUid)
        .orderBy("sort", descending: true)
        .limit(50)
        .snapshots();
  }

  Stream<QuerySnapshot> getAcumulativePoints(String clientUid) {
    return _firestore
        .collection('acumulativePoints')
        .where("clientUid", isEqualTo: clientUid)
        .orderBy("sort", descending: true)
        .limit(50)
        .snapshots();
  }

  Future<void> addAcumulativePoints(
      String comment,
      double accumulatedPoints,
      int year,
      int month,
      int day,
      int hour,
      int minutes,
      int sort,
      value) async {
    WriteBatch batch = _firestore.batch();
    DocumentReference newSetPost =
        _firestore.collection('acumulativePoints').doc();
    DocumentReference newUpdatePost =
        _firestore.collection('users').doc(value["uid"]);
    batch.set(newSetPost, {
      'uid': newSetPost.id,
      'year': year,
      'month': month,
      'day': day,
      'hour': hour,
      'minutes': minutes,
      'sort': sort,
      'comment': comment,
      'clientUid': value["uid"],
      'clientName': value["name"],
      'accumulatedPoints': accumulatedPoints,
    });
    batch.update(newUpdatePost, {
      'uid': value["uid"],
      'name': value["name"],
      'phone': value["phone"],
      'birthDay': value["birthDay"],
      'email': value["email"],
      'redeemedPoints': value["redeemedPoints"],
      'accumulatedPoints': value["accumulatedPoints"],
      'photoURL': value["photoURL"],
      'token': value["token"],
      'type': value["type"]
    });
    try {
      return batch.commit();
    } catch (e) {
      return;
    }
  }
}
