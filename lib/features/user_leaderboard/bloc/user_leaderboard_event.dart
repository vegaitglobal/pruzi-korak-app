part of 'user_leaderboard_bloc.dart';

sealed class UserLeaderboardEvent extends Equatable {
  const UserLeaderboardEvent();
}

final class LoadUserLeaderboard extends UserLeaderboardEvent {
  @override
  List<Object> get props => [];
}
