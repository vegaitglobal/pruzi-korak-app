import 'package:pruzi_korak/core/utils/app_logger.dart';
import 'package:pruzi_korak/domain/leaderboard/leaderboard_model.dart';
import 'package:pruzi_korak/domain/leaderboard/team_leaderboard_model.dart';
import 'package:pruzi_korak/domain/leaderboard/top_three_leaderboard_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'leaderboard_repository.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final SupabaseClient _client;

  LeaderboardRepositoryImpl(this._client);

  @override
  Future<({TopThreeLeaderboardModel<LeaderboardModel> topThree, List<LeaderboardModel> list})>
  getUsersLeaderboard() async {
    try {
      final response = await _client.rpc(
        'get_my_team_users_with_distance');

      AppLogger.logInfo("getUsersLeaderboard response: ${response}");

      final rawList = response as List;

      rawList.sort((a, b) {
        final aDistance = double.tryParse(a['total_distance'].toString()) ?? 0;
        final bDistance = double.tryParse(b['total_distance'].toString()) ?? 0;
        return bDistance.compareTo(aDistance);
      });

      final List<LeaderboardModel> leaderboard =
          rawList.asMap().entries.map((entry) {
            final index = entry.key;
            final json = entry.value as Map<String, dynamic>;
            final rank = (index + 1).toString();
            return LeaderboardModel.fromJson(json, rank: rank);
          }).toList();

      final topThree = TopThreeLeaderboardModel.fromList(leaderboard);
      AppLogger.logInfo("Top three leaderboard: $topThree");
      final others =
          leaderboard.length > 3
              ? leaderboard.sublist(3)
              : <LeaderboardModel>[];

      return (topThree: topThree, list: others);
    } catch (e) {
      AppLogger.logError("Failed to fetch leaderboard: $e");
      throw Exception('Failed to fetch leaderboard: $e');
    }
  }

  @override
  Future<({TopThreeLeaderboardModel<TeamLeaderboardModel> topThree, List<TeamLeaderboardModel> list})>
  getTeamLeaderboard() async {
    try {
      final response = await _client.rpc(
        'get_campaign_teams_with_distance');

      AppLogger.logInfo("getTeamLeaderboard response: ${response}");

      final rawList = response as List;

      rawList.sort((a, b) {
        final aDistance = double.tryParse(a['total_distance'].toString()) ?? 0;
        final bDistance = double.tryParse(b['total_distance'].toString()) ?? 0;
        return bDistance.compareTo(aDistance);
      });

      final List<TeamLeaderboardModel> leaderboard =
          rawList.asMap().entries.map((entry) {
            final index = entry.key;
            final json = entry.value as Map<String, dynamic>;
            final rank = (index + 1).toString();
            return TeamLeaderboardModel.fromJson(json, rank: rank);
          }).toList();

      final topThree = TopThreeLeaderboardModel.fromList(leaderboard);
      AppLogger.logInfo("Top three leaderboard: $topThree");
      final others =
          leaderboard.length > 3
              ? leaderboard.sublist(3)
              : <TeamLeaderboardModel>[];

      return (topThree: topThree, list: others);
    } catch (e) {
      AppLogger.logError("Failed to fetch leaderboard: $e");
      throw Exception('Failed to fetch leaderboard: $e');
    }
  }

  @override
  Future<List<LeaderboardModel>> getUsersLeaderboardByTeam(String teamId) async {
    try {
      final response = await _client.rpc(
        'get_team_info',
        params: {'input_team_id': teamId},
      );

      AppLogger.logInfo("getUsersLeaderboardByTeam response: $response");

      final rawList = response as List;

      rawList.sort((a, b) {
        final aDistance = double.tryParse(a['total_distance'].toString()) ?? 0;
        final bDistance = double.tryParse(b['total_distance'].toString()) ?? 0;
        return bDistance.compareTo(aDistance);
      });

      final List<LeaderboardModel> leaderboard =
          rawList.asMap().entries.map((entry) {
            final index = entry.key;
            final json = entry.value as Map<String, dynamic>;
            final rank = (index + 1).toString();
            return LeaderboardModel.fromJson(json, rank: rank);
          }).toList();

      return leaderboard;
    } catch (e) {
      AppLogger.logError("Failed to fetch team users: $e");
      throw Exception('Failed to fetch team users: $e');
    }
  }
}
