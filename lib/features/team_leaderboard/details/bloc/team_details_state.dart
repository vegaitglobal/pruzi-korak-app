part of 'team_details_bloc.dart';

sealed class TeamDetailsState extends Equatable {
  const TeamDetailsState();

  @override
  List<Object> get props => [];
}

final class TeamDetailsLoading extends TeamDetailsState {
  const TeamDetailsLoading();
}

final class TeamDetailsLoaded extends TeamDetailsState {
  final String totalDistance;
  final List<LeaderboardModel> leaderboardList;

  const TeamDetailsLoaded({
    required this.totalDistance,
    required this.leaderboardList,
  });

  @override
  List<Object> get props => [totalDistance, leaderboardList];
}

final class TeamDetailsError extends TeamDetailsState {
  const TeamDetailsError();
}

final class TeamDetailsEmpty extends TeamDetailsState {
  const TeamDetailsEmpty();
}
