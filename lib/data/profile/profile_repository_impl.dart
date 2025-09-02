import 'package:pruzi_korak/core/utils/app_logger.dart';
import 'package:pruzi_korak/data/profile/profile_repository.dart';
import 'package:pruzi_korak/domain/profile/user_rank_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseClient _client;
  final int _maxRetries;

  ProfileRepositoryImpl(this._client, {int maxRetries = 3})
      : _maxRetries = maxRetries;

  @override
  Future<UserRankModel?> getUserRanks() async {
    int attempts = 0;

    while (true) {
      attempts++;
      try {
        final response = await _client.rpc('get_my_user_ranks');

        AppLogger.logInfo("getUserRanks response: $response");

        final rawList = response as List;
        return rawList
            .map((item) => UserRankModel.fromJson(item as Map<String, dynamic>))
            .firstOrNull;
      } catch (e) {
        if (attempts >= _maxRetries) {
          AppLogger.logError(
              "Failed to fetch user ranks after $_maxRetries attempts: $e");
          throw Exception(
              'Failed to fetch user ranks after $_maxRetries attempts: $e');
        }

        final delayMs = 1000 * (1 << (attempts - 1));
        AppLogger.logWarning(
            "Retry $attempts/$_maxRetries for getUserRanks after ${delayMs}ms. Error: $e");

        await Future.delayed(Duration(milliseconds: delayMs));
      }
    }
  }
}
