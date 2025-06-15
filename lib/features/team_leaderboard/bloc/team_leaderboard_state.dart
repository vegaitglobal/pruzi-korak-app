part of 'team_leaderboard_bloc.dart';

sealed class TeamLeaderboardState extends Equatable {
  const TeamLeaderboardState();

  @override
  List<Object> get props => [];
}

final class TeamLeaderboardInitial extends TeamLeaderboardState {
  const TeamLeaderboardInitial();
}

final class TeamLeaderboardLoading extends TeamLeaderboardState {
  const TeamLeaderboardLoading();
}

final class TeamLeaderboardLoaded extends TeamLeaderboardState {
  final List<LeaderboardModel> leaderboardList;

  const TeamLeaderboardLoaded({required this.leaderboardList});

  @override
  List<Object> get props => [leaderboardList];
}

final class TeamLeaderboardError extends TeamLeaderboardState {
  const TeamLeaderboardError();
}

final class TeamLeaderboardEmpty extends TeamLeaderboardState {
  const TeamLeaderboardEmpty();
}
