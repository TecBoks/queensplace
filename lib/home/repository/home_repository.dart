import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bequeen/home/repository/home_firebase_api.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  final _firebaseHomeAPI = FirebaseHomeAPI();

  Future<List<dynamic>> getServices() => _firebaseHomeAPI.getServices();

  Future<List<dynamic>> getWorkers() => _firebaseHomeAPI.getWorkers();

  Future<List<dynamic>> getClients() => _firebaseHomeAPI.getClients();

  Stream<QuerySnapshot> getGlobalAppointments(int year, int month, int day) =>
      _firebaseHomeAPI.getGlobalAppointments(year, month, day);

  Future<void> createAppointment(value) =>
      _firebaseHomeAPI.createAppointment(value);

  Future<void> deleteAppoinment(String uid) =>
      _firebaseHomeAPI.deleteAppoinment(uid);

  Stream<QuerySnapshot> getAppointmentsClientWorker(
          String uid, int limit, String type) =>
      _firebaseHomeAPI.getAppointmentsClientWorker(uid, limit, type);

  Future<http.Response> sendPushNotification(
          String token, String title, String body) =>
      _firebaseHomeAPI.sendPushNotification(token, title, body);
}
