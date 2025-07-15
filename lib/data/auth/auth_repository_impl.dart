import 'package:flutter/foundation.dart';
import 'package:pruzi_korak/core/utils/app_logger.dart';
import 'package:pruzi_korak/data/local/local_storage.dart';
import 'package:pruzi_korak/domain/organization/OrganizationRepository.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';

import '../../domain/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;
  final AppLocalStorage _localStorage;
  final OrganizationRepository _organizationRepository;
  final MobileDeviceIdentifier _mobileDeviceIdentifier;

  AuthRepositoryImpl(
    this._client,
    this._localStorage,
    this._organizationRepository,
    this._mobileDeviceIdentifier,
  );

  @override
  Future<void> logout() async {
    try {
      await _rpcLogout();
      await _client.auth.signOut();
      await _localStorage.clearUserData();
    } catch (e) {
      throw Exception('Failed to log out: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final session = _client.auth.currentSession;
    final user = await _localStorage.getUser();
    if (session == null || user == null) return false;
    return true;
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      var response = await _client.auth.signInWithPassword(
        password: password,
        email: email,
      );
      // Verify device identifier
      await _rpcLogin(email, password);

      // Fetch and save user data
      await fetchAndSaveUser();
      await fetchAndSaveOrganizationInfo();

      return response.user;
    } on UnsupportedDeviceIdentifierException {
      // Session must be cleared because user is not allowed on this device
      await _client.auth.signOut();
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  Future<void> _rpcLogin(String email, String password) async {
    try {
      final deviceId = await _getDeviceIdentifier();
      if (deviceId == null) throw UnsupportedDeviceIdentifierException();

      final response = await _client.rpc(
        'log_in',
        params: {'input_email': email, 'input_passcode': password, 'device_id': deviceId},
      );

      if (response is Map<String, dynamic> && response['error'] != null) {
        throw UnsupportedDeviceIdentifierException();
      }
    } catch (e) {
      if (kDebugMode) AppLogger.logDebug('RPC Login Error: $e');
      throw UnsupportedDeviceIdentifierException();
    }
  }

  Future<void> _rpcLogout() async {
    try {
      final deviceId = await _getDeviceIdentifier();
      if (deviceId == null) throw UnsupportedDeviceIdentifierException();

      final response = await _client.rpc('log_out');

      if (response is Map<String, dynamic> && response['error'] != null) {
        throw LogoutFailedException();
      }
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  Future<String?> _getDeviceIdentifier() async {
    try {
      final deviceIdentifier = await _mobileDeviceIdentifier.getDeviceId();
      return deviceIdentifier;
    } catch (e) {
      if (kDebugMode) print('Error getting device identifier: $e');
      return null;
    }
  }

  // Mark: User data

  Future<void> fetchAndSaveUser() async {
    try {
      final response = await _client.rpc('get_my_data');
      final user = UserModel.fromJson(
        (response as List).first as Map<String, dynamic>,
      );
      await _localStorage.saveUser(user);
    } catch (e) {
      throw Exception('Failed to fetch home data: $e');
    }
  }

  Future<void> fetchAndSaveOrganizationInfo() async {
    try {
      final organizationData = await _organizationRepository.fetchBySession();
      await _localStorage.saveOrganizationInfo(
        organizationData.heading,
        organizationData.logoUrl,
      );
    } catch (e) {
      throw Exception('Failed to fetch organization data: $e');
    }
  }
}

sealed class AuthExceptions implements Exception {}

class UnsupportedPlatformException implements AuthExceptions {}

class UnsupportedDeviceIdentifierException implements AuthExceptions {}

class LogoutFailedException implements AuthExceptions {}
