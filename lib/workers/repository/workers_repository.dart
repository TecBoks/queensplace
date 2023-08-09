import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bequeen/workers/repository/workers_firebase_api.dart';

class WorkersRepository {
  final _firebaseWorkersAPI = FirebaseWorkersAPI();

  Stream<QuerySnapshot> getWorkers() => _firebaseWorkersAPI.getWorkers();

  Future<void> createWorker(
          String birthDay, String email, String name, String phone) =>
      _firebaseWorkersAPI.createWorker(birthDay, email, name, phone);

  Future<void> deleteWorker(String uid) =>
      _firebaseWorkersAPI.deleteWorker(uid);

  Stream<QuerySnapshot> getAppointments(String workerUid, int limit) =>
      _firebaseWorkersAPI.getAppointments(workerUid, limit);

  Future<void> updateDataUser(value) =>
      _firebaseWorkersAPI.updateDataUser(value);

  Future<List<dynamic>> getServices() => _firebaseWorkersAPI.getServices();
}
