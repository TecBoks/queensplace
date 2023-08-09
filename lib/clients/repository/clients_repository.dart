import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bequeen/clients/repository/clients_firebase_api.dart';

class ClientsRepository {
  final _firebaseClientsAPI = FirebaseClientsAPI();

  Stream<QuerySnapshot> getClients() => _firebaseClientsAPI.getClients();

  Future<void> createClient(String name, String email, String phone) =>
      _firebaseClientsAPI.createClient(name, email, phone);

  Future<void> deleteClient(String uid) =>
      _firebaseClientsAPI.deleteClient(uid);

  Stream<QuerySnapshot> getAppointments(String clientUid, int limit) =>
      _firebaseClientsAPI.getAppointments(clientUid, limit);

  Stream<QuerySnapshot> getRedeemedPoints(String clientUid) =>
      _firebaseClientsAPI.getRedeemedPoints(clientUid);

  Future<void> updateRedeemPoints(value) =>
      _firebaseClientsAPI.updateRedeemPoints(value);
}
