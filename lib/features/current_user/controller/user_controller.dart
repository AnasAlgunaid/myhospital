import 'package:myhospital/features/current_user/models/user_model.dart';
import 'package:myhospital/features/current_user/repository/user_repository.dart';

class UserController {
  final UserRepository _repository;

  UserController(this._repository);

  Future<UserModel?> fetchUser(String userId) async {
    return await _repository.fetchUser(userId);
  }

  Future<void> updateUserProfile(String userId, UserModel updatedUser) async {
    await _repository.updateUser(userId, updatedUser);
  }
}
