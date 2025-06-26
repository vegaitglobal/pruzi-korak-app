import 'package:pruzi_korak/domain/leaderboard/leaderboard_model.dart';
import 'package:pruzi_korak/domain/leaderboard/team_leaderboard_model.dart';
import 'package:pruzi_korak/domain/leaderboard/top_three_leaderboard_model.dart';

abstract class LeaderboardRepository {
  Future<({TopThreeLeaderboardModel<LeaderboardModel> topThree, List<LeaderboardModel> list})>
      getUsersLeaderboard();

  Future<({TopThreeLeaderboardModel<TeamLeaderboardModel> topThree, List<TeamLeaderboardModel> list})>
      getTeamLeaderboard();
}