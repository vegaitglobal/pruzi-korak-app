part of 'user_leaderboard_bloc.dart';

sealed class UserLeaderboardState extends Equatable {
  const UserLeaderboardState();
}

final class UserLeaderboardLoading extends UserLeaderboardState {
  @override
  List<Object> get props => [];
}

final class UserLeaderboardLoaded extends UserLeaderboardState {
  final List<StepsModel> stepsList;

  const UserLeaderboardLoaded({required this.stepsList});

  @override
  List<Object> get props => [stepsList];
}

final class UserLeaderboardError extends UserLeaderboardState {
  final String errorMessage;

  const UserLeaderboardError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
