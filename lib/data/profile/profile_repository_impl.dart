import 'package:pruzi_korak/core/utils/app_logger.dart';
import 'package:pruzi_korak/data/profile/profile_repository.dart';
import 'package:pruzi_korak/domain/profile/user_rank_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseClient _client;

  ProfileRepositoryImpl(this._client);

  @override
  Future<UserRankModel?> getUserRanks() async {
    try {
      final response = await _client.rpc('get_my_user_ranks');

      AppLogger.logInfo("getUserRanks response: $response");

      final rawList = response as List;
      return rawList
          .map((item) => UserRankModel.fromJson(item as Map<String, dynamic>))
          .firstOrNull;
    } catch (e) {
      AppLogger.logError("Failed to fetch user ranks: $e");
      throw Exception('Failed to fetch user ranks: $e');
    }
  }
}
