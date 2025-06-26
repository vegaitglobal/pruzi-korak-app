part of 'user_leaderboard_bloc.dart';

sealed class UserLeaderboardState extends Equatable {
  const UserLeaderboardState();

  @override
  List<Object> get props => [];
}

final class UserLeaderboardLoading extends UserLeaderboardState {
  const UserLeaderboardLoading();
}

final class UserLeaderboardLoaded extends UserLeaderboardState {
  final TopThreeLeaderboardModel<LeaderboardModel> topThreeLeaderboardModel;
  final List<LeaderboardModel> leaderboardList;

  const UserLeaderboardLoaded({
    required this.topThreeLeaderboardModel,
    required this.leaderboardList,
  });

  @override
  List<Object> get props => [topThreeLeaderboardModel, leaderboardList];
}

final class UserLeaderboardError extends UserLeaderboardState {
  const UserLeaderboardError();
}

final class UserLeaderboardEmpty extends UserLeaderboardState {
  @override
  List<Object> get props => [];
}
