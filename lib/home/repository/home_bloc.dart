import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:bequeen/home/repository/home_repository.dart';
import 'package:http/http.dart' as http;

class HomeBloc implements Bloc {
  final _homeRepository = HomeRepository();

  Future<List<dynamic>> getServices() {
    return _homeRepository.getServices();
  }

  Future<List<dynamic>> getWorkers() {
    return _homeRepository.getWorkers();
  }

  Future<List<dynamic>> getClients() {
    return _homeRepository.getClients();
  }

  Stream<QuerySnapshot> getGlobalAppointments(int year, int month, int day) {
    return _homeRepository.getGlobalAppointments(year, month, day);
  }


  Future<void> createAppointment(value) {
    return _homeRepository.createAppointment(value);
  }

  Future<http.Response> sendPushNotification(
      String token, String title, String body) {
    return _homeRepository.sendPushNotification(token, title, body);
  }

  Future<void> deleteAppoinment(String uid) {
    return _homeRepository.deleteAppoinment(uid);
  }

  Stream<QuerySnapshot> getAppointmentsClientWorker(
      String uid, int limit, String type) {
    return _homeRepository.getAppointmentsClientWorker(uid, limit, type);
  }

  @override
  void dispose() {}
}

final homeBloc = HomeBloc();
