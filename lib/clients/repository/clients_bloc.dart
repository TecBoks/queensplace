import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:bequeen/clients/repository/clients_repository.dart';

class ClientsBloc implements Bloc {
  final _clientsRepository = ClientsRepository();

  Stream<QuerySnapshot> getClients() {
    return _clientsRepository.getClients();
  }

  Future<void> createClient(String name, String email, String phone) {
    return _clientsRepository.createClient(name, email, phone);
  }

  Future<void> deleteClient(String uid) {
    return _clientsRepository.deleteClient(uid);
  }

  Stream<QuerySnapshot> getAppointments(String clientUid, int limit) {
    return _clientsRepository.getAppointments(clientUid, limit);
  }

  Stream<QuerySnapshot> getRedeemedPoints(String clientUid) {
    return _clientsRepository.getRedeemedPoints(clientUid);
  }

  Future<void> updateRedeemPoints(value) {
    return _clientsRepository.updateRedeemPoints(value);
  }

  @override
  void dispose() {}
}

final clientsBloc = ClientsBloc();
