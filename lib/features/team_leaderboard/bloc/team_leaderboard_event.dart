part of 'team_leaderboard_bloc.dart';

sealed class TeamLeaderboardEvent extends Equatable {
  const TeamLeaderboardEvent();
}

final class LoadTeamLeaderboard extends TeamLeaderboardEvent {
  const LoadTeamLeaderboard();

  @override
  List<Object> get props => [];
}
