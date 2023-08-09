import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:bequeen/loyalty_points/repository/loyalty_points_repository.dart';

class LoyaltyPointsBloc implements Bloc {
  final _loyaltyPointsRepository = LoyaltyPointsRepository();

  Stream<QuerySnapshot> getClients(String phone) {
    return _loyaltyPointsRepository.getClients(phone);
  }

  Future<List<dynamic>> getTempPoints(String uid) {
    return _loyaltyPointsRepository.getTempPoints(uid);
  }

  Future<void> updateDataUser(String tempPointsUid, value) {
    return _loyaltyPointsRepository.updateDataUser(tempPointsUid, value);
  }

  Future<DocumentSnapshot> getDataUser(String userId) {
    return _loyaltyPointsRepository.getDataUser(userId);
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
      value) {
    return _loyaltyPointsRepository.redeemPoints(comment, correlative,
        redeemedPoints, qty, year, month, day, hour, minutes, sort, value);
  }

  Stream<QuerySnapshot> getRedeemedPoints(String clientUid) {
    return _loyaltyPointsRepository.getRedeemedPoints(clientUid);
  }

  Stream<QuerySnapshot> getAcumulativePoints(String clientUid) {
    return _loyaltyPointsRepository.getAcumulativePoints(clientUid);
  }

  Future<void> addAcumulativePoints(String comment, double accumulatedPoints,
      int year, int month, int day, int hour, int minutes, int sort, value) {
    return _loyaltyPointsRepository.addAcumulativePoints(comment,
        accumulatedPoints, year, month, day, hour, minutes, sort, value);
  }

  @override
  void dispose() {}
}

final loyaltyPointsBloc = LoyaltyPointsBloc();
