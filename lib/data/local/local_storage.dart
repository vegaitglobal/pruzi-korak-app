import 'package:pruzi_korak/domain/user/user_model.dart';

abstract class AppLocalStorage {
  Future<void> saveUser(UserModel userModel);

  Future<UserModel?> getUser();
}