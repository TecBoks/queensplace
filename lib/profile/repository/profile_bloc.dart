import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:bequeen/profile/repository/profile_repository.dart';

class ProfileBloc implements Bloc {
  final _profileRepository = ProfileRepository();

  Future<void> updateDataUser(String userId, value) {
    return _profileRepository.updateDataUser(userId, value);
  }

  @override
  void dispose() {}
}

final profileBloc = ProfileBloc();
