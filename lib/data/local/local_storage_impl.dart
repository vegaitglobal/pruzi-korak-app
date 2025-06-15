import 'dart:convert';

import 'package:pruzi_korak/data/local/local_storage.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocalStorageImpl implements AppLocalStorage {
  final SharedPreferences _prefs;

  static const _userKey = 'user_model';

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
  }
}
