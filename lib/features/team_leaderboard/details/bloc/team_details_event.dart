part of 'team_details_bloc.dart';

sealed class TeamDetailsEvent extends Equatable {
  const TeamDetailsEvent();
}

final class FetchTeamDetailsEvent extends TeamDetailsEvent {
  final String teamId;

  const FetchTeamDetailsEvent({required this.teamId});

  @override
  List<Object> get props => [teamId];
}
