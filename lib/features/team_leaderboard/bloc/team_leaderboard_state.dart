part of 'team_leaderboard_bloc.dart';

sealed class TeamLeaderboardState extends Equatable {
  const TeamLeaderboardState();

  @override
  List<Object> get props => [];
}

final class TeamLeaderboardLoading extends TeamLeaderboardState {
  const TeamLeaderboardLoading();
}

final class TeamLeaderboardLoaded extends TeamLeaderboardState {
  final TopThreeLeaderboardModel topThreeLeaderboardModel;
  final List<LeaderboardModel> leaderboardList;

  const TeamLeaderboardLoaded({
    required this.topThreeLeaderboardModel,
    required this.leaderboardList,
  });

  @override
  List<Object> get props => [topThreeLeaderboardModel, leaderboardList];
}

final class TeamLeaderboardError extends TeamLeaderboardState {
  const TeamLeaderboardError();
}

final class TeamLeaderboardEmpty extends TeamLeaderboardState {
  const TeamLeaderboardEmpty();
}
