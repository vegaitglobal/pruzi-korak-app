import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pruzi_korak/core/exception/exception_handler.dart';
import 'package:pruzi_korak/core/utils/app_logger.dart';
import 'package:pruzi_korak/data/local/local_storage.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../domain/auth/AuthRepository.dart';

const String _device_validation_endpoint = "validate_and_register_device";
const String _device_id_key = "device_id";
const String _user_id_key = "input_user_id";

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;
  final AppLocalStorage _localStorage;

  AuthRepositoryImpl(this._client, this._localStorage);

  @override
  Future<void> logout() async{
    try {
      await _client.auth.signOut();
      await _localStorage.clearUserData();
      AppLogger.logInfo('User logged out successfully');
    } catch (e) {
      AppLogger.logError('Error during logout: $e');
      throw Exception('Failed to log out: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return handleSupabaseExceptions(() async {
      final session = _client.auth.currentSession;
      if (session == null) return false;

      // TODO: Check if we have a valid tenant ID

      return true;
    });
  }

  Future<String?> _getDeviceIdentifier() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _readAndroidDeviceIdentifier(
          await DeviceInfoPlugin().androidInfo,
        );
      case TargetPlatform.iOS:
        return _getIosDeviceIdentifier(await DeviceInfoPlugin().iosInfo);

      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        throw UnsupportedPlatformException;
    }
  }

  String? _getIosDeviceIdentifier(IosDeviceInfo data) =>
      data.identifierForVendor;

  String? _readAndroidDeviceIdentifier(AndroidDeviceInfo build) => build.id;

  @override
  Future<User?> login(String email, String password) async {
    try {
      var response = await _client.auth.signInWithPassword(
        password: password,
        email: email,
      );
      var isDeviceValid = await _isDeviceValid(response.user!.id);
      fetchAndSaveUser();

      if (isDeviceValid) return response.user;
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<bool> _isDeviceValid(String userId) async {
    try {
      String? deviceId = await _getDeviceIdentifier();
      if (deviceId == null) throw UnsupportedDeviceIdentifierState();
      return await _client.rpc(
        _device_validation_endpoint,
        params: {_user_id_key: userId, _device_id_key: deviceId},
      );
    } on Exception catch (_) {
      return false;
    }
  }

  Future<void> fetchAndSaveUser() async {
    try {
      final response = await _client.rpc('get_my_data');
      AppLogger.logInfo('Response from get_my_data: $response');

      final user = UserModel.fromJson((response as List).first as Map<String, dynamic>);
      AppLogger.logInfo('User data fetched: ${user.toJson()}');

      await _localStorage.saveUser(user);
    } catch (e) {
      throw Exception('Failed to fetch home data: $e');
    }
  }
}

sealed class AuthExceptions implements Exception {}

class UnsupportedPlatformException implements AuthExceptions {}

class UnsupportedDeviceIdentifierState implements AuthExceptions {}
