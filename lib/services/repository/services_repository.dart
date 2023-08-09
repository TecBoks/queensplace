import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bequeen/services/repository/services_firebase_api.dart';

class ServicesRepository {
  final _firebaseServicesAPI = FirebaseServicesAPI();

  Stream<QuerySnapshot> getServices() => _firebaseServicesAPI.getServices();

  Future<void> createService(String name, int duration, double cost) =>
      _firebaseServicesAPI.createService(name, duration, cost);

  Future<void> deleteService(String uid) =>
      _firebaseServicesAPI.deleteService(uid);
}
