import 'dart:convert';

import 'package:pruzi_korak/data/local/local_storage.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocalStorageImpl implements AppLocalStorage {
  final SharedPreferences _prefs;

  static const _userKey = 'user_model';
  static const _companyNameKey = 'company_name';
  static const _logoUrlKey = 'logo_url';

  AppLocalStorageImpl(this._prefs);

  @override
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, userJson);
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  @override
  Future<void> clearUserData() async {
    await _prefs.remove(_userKey);
    await _prefs.remove(_companyNameKey);
    await _prefs.remove(_logoUrlKey);
  }

  @override
  Future<void> saveOrganizationInfo(String companyName, String logoUrl) async {
    await _prefs.setString(_companyNameKey, companyName);
    await _prefs.setString(_logoUrlKey, logoUrl);
  }

  @override
  Future<String?> getCompanyName() async {
    return _prefs.getString(_companyNameKey);
  }

  @override
  Future<String?> getLogoUrl() async {
    return _prefs.getString(_logoUrlKey);
  }
}
