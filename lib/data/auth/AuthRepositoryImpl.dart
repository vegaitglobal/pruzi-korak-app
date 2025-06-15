import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pruzi_korak/core/exception/exception_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../domain/auth/AuthRepository.dart';

const String _device_validation_endpoint = "validate_and_register_device";
const String _device_id_key = "device_id";
const String _user_id_key = "input_user_id";
const String _email_key = "input_email";
const String _pass_key = "input_passcode";
const String _device_key = "device_id";

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;

  AuthRepositoryImpl(this._client);

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
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
}

sealed class AuthExceptions implements Exception {}

class UnsupportedPlatformException implements AuthExceptions {}

class IllegalUserAgent implements AuthExceptions {}

class UnsupportedDeviceIdentifierState implements AuthExceptions {}

class IllegalArgumentException implements AuthExceptions {}
