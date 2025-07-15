import 'package:pruzi_korak/domain/user/user_model.dart';

abstract class AppLocalStorage {
  Future<void> saveUser(UserModel userModel);

  Future<UserModel?> getUser();

  Future<void> clearUserData();

  Future<void> saveOrganizationInfo(String companyName, String logoUrl);

  Future<String?> getCompanyName();

  Future<String?> getLogoUrl();
}