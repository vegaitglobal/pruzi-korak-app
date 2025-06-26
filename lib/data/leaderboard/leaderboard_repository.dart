import 'package:pruzi_korak/domain/leaderboard/leaderboard_model.dart';
import 'package:pruzi_korak/domain/leaderboard/top_three_leaderboard_model.dart';

abstract class LeaderboardRepository {
  Future<({TopThreeLeaderboardModel topThree, List<LeaderboardModel> list})> getUsersLeaderboard();
  Future<({TopThreeLeaderboardModel topThree, List<LeaderboardModel> list})> getTeamLeaderboard();

}