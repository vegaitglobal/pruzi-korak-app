import 'package:flutter/foundation.dart';
import 'package:pruzi_korak/data/local/local_storage.dart';
import 'package:pruzi_korak/domain/organization/OrganizationRepository.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';

import '../../domain/auth/AuthRepository.dart';

const String _device_validation_endpoint = "validate_and_register_device";
const String _device_id_key = "device_id";
const String _user_id_key = "input_user_id";

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;
  final AppLocalStorage _localStorage;
  final OrganizationRepository _organizationRepository;
  final MobileDeviceIdentifier _mobileDeviceIdentifier;

  AuthRepositoryImpl(this._client, this._localStorage, this._organizationRepository, this._mobileDeviceIdentifier);

  @override
  Future<void> logout() async {
    try {
      await _client.auth.signOut();
      await _localStorage.clearUserData();
    } catch (e) {
      throw Exception('Failed to log out: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final session = _client.auth.currentSession;
    if (session == null) return false;
    return true;
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

  @override
  Future<User?> login(String email, String password) async {
    try {
      var response = await _client.auth.signInWithPassword(
        password: password,
        email: email,
      );
      var isDeviceValid = await _isDeviceValid(response.user!.id);
      await fetchAndSaveUser();
      await fetchAndSaveOrganizationInfo();

      if (isDeviceValid) return response.user;
    } on Exception {
      rethrow;
    }
    return null;
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

class UnsupportedDeviceIdentifierState implements AuthExceptions {}
