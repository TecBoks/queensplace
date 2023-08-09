import 'package:bequeen/profile/repository/profile_firebase_api.dart';

class ProfileRepository {
  final _firebaseProfileAPI = FirebaseProfileAPI();

  Future<void> updateDataUser(String userId, value) =>
      _firebaseProfileAPI.updateDataUser(userId, value);
}
