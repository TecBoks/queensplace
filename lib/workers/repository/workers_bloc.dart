import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:bequeen/workers/repository/workers_repository.dart';

class WorkersBloc implements Bloc {
  final _workersRepository = WorkersRepository();

  Stream<QuerySnapshot> getWorkers() {
    return _workersRepository.getWorkers();
  }

  Future<void> createWorker(
      String birthDay, String email, String name, String phone) {
    return _workersRepository.createWorker(birthDay, email, name, phone);
  }

  Future<void> deleteWorker(String uid) {
    return _workersRepository.deleteWorker(uid);
  }

  Stream<QuerySnapshot> getAppointments(String workerUid, int limit) {
    return _workersRepository.getAppointments(workerUid, limit);
  }

  Future<List<dynamic>> getServices() {
    return _workersRepository.getServices();
  }

  Future<void> updateDataUser(value) {
    return _workersRepository.updateDataUser(value);
  }

  @override
  void dispose() {}
}

final workersBloc = WorkersBloc();
