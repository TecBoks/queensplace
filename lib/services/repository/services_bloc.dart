import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:bequeen/services/repository/services_repository.dart';

class ServicesBloc implements Bloc {
  final _servicesRepository = ServicesRepository();

  Stream<QuerySnapshot> getServices() {
    return _servicesRepository.getServices();
  }

  Future<void> createService(String name, int duration, double cost) {
    return _servicesRepository.createService(name, duration, cost);
  }

  Future<void> deleteService(String uid) {
    return _servicesRepository.deleteService(uid);
  }

  @override
  void dispose() {}
}

final servicesBloc = ServicesBloc();
