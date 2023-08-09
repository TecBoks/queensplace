import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bequeen/loyalty_points/repository/loyalty_points_firebase_api.dart';

class LoyaltyPointsRepository {
  final _loyaltyPointsFirebaseAPI = LoyaltyPointsFirebaseAPI();

  Stream<QuerySnapshot> getClients(String phone) =>
      _loyaltyPointsFirebaseAPI.getClients(phone);

  Future<List<dynamic>> getTempPoints(String uid) =>
      _loyaltyPointsFirebaseAPI.getTempPoints(uid);

  Future<void> updateDataUser(String tempPointsUid, value) =>
      _loyaltyPointsFirebaseAPI.updateDataUser(tempPointsUid, value);

  Future<DocumentSnapshot> getDataUser(String userId) =>
      _loyaltyPointsFirebaseAPI.getDataUser(userId);

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
          value) =>
      _loyaltyPointsFirebaseAPI.redeemPoints(comment, correlative,
          redeemedPoints, qty, year, month, day, hour, minutes, sort, value);

  Stream<QuerySnapshot> getRedeemedPoints(String clientUid) =>
      _loyaltyPointsFirebaseAPI.getRedeemedPoints(clientUid);

  Stream<QuerySnapshot> getAcumulativePoints(String clientUid) =>
      _loyaltyPointsFirebaseAPI.getAcumulativePoints(clientUid);

  Future<void> addAcumulativePoints(
          String comment,
          double accumulatedPoints,
          int year,
          int month,
          int day,
          int hour,
          int minutes,
          int sort,
          value) =>
      _loyaltyPointsFirebaseAPI.addAcumulativePoints(comment, accumulatedPoints,
           year, month, day, hour, minutes, sort, value);
}
