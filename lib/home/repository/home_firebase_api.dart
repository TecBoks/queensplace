import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseHomeAPI {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<List<dynamic>> getWorkers() async {
    QuerySnapshot qs = await _firestore
        .collection('users')
        .where("type", isEqualTo: "worker")
        .get();
    return qs.docs
        .map((e) => {
              'name': e.data().toString().contains('name') ? e.get('name') : '',
              'email':
                  e.data().toString().contains('email') ? e.get('email') : '',
              'services': e.data().toString().contains('services')
                  ? e.get('services')
                  : [],
              'token':
                  e.data().toString().contains('token') ? e.get('token') : '',
              'uid': e.data().toString().contains('uid') ? e.get('uid') : ''
            })
        .toList();
  }

  Future<List<dynamic>> getClients() async {
    QuerySnapshot qs = await _firestore
        .collection('users')
        .where("type", isEqualTo: "client")
        .get();
    return qs.docs
        .map((e) => {
              'name': e.data().toString().contains('name') ? e.get('name') : '',
              'email':
                  e.data().toString().contains('email') ? e.get('email') : '',
              'token':
                  e.data().toString().contains('token') ? e.get('token') : '',
              'uid': e.data().toString().contains('uid') ? e.get('uid') : ''
            })
        .toList();
  }

  Stream<QuerySnapshot> getGlobalAppointments(int year, int month, int day) {
    return _firestore
        .collection('appointments')
        .where('year', isEqualTo: year)
        .where('month', isEqualTo: month)
        .where('day', isEqualTo: day)
        .snapshots();
  }

  Stream<QuerySnapshot> getAppointmentsClientWorker(
      String uid, int limit, String type) {
    return _firestore
        .collection('appointments')
        .where((type == "worker") ? 'workerUid' : 'clientUid', isEqualTo: uid)
        .orderBy("sort", descending: true)
        .limit(limit)
        .snapshots();
  }

  Future<void> createAppointment(value) async {
    var newValue = value;
    WriteBatch batch = _firestore.batch();
    DocumentReference newPost = _firestore.collection('appointments').doc();
    DocumentReference newPostTempPoints =
        _firestore.collection('tempPoints').doc(newPost.id);
    newValue["uid"] = newPost.id;
    batch.set(newPost, newValue);
    batch.set(newPostTempPoints, {
      "uid": newPostTempPoints.id,
      "points": newValue["serviceCost"],
      "clientUid": newValue["clientUid"],
      "endDate": newValue["endDate"],
      "appointmentUid": newValue["uid"]
    });
    try {
      return batch.commit();
    } catch (e) {
      return;
    }
  }

  Future<http.Response> sendPushNotification(
      String token, String title, String body) async {
    final response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            body: json.encode({
              "to": token,
              "notification": {
                "body": body,
                "content_available": true,
                "priority": "high",
                "title": title
              }
            }),
            headers: {
          'Authorization':
              'key=AAAANCfU4vI:APA91bFcrqpB-aMG85kwqpP9a7DpBhZV3u95UFzUfPgJP4bt4v-0jSjVr0fDd2rLmqCJmT2_6VJh1ufun1VswBq2SemkKP1ot8d-4RF8RN_QrdKvRd15Tigl_nmOMJlb8RWkjoC05_Cp',
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed');
    }
  }

  Future<void> deleteAppoinment(String appoUid) async {
    WriteBatch batch = _firestore.batch();
    DocumentReference deleteAppoinment =
        _firestore.collection('appointments').doc(appoUid);
    DocumentReference deleteTempPoints =
        _firestore.collection('tempPoints').doc(appoUid);
    batch.delete(deleteAppoinment);
    batch.delete(deleteTempPoints);
    try {
      return batch.commit();
    } catch (e) {
      return;
    }
  }
}
