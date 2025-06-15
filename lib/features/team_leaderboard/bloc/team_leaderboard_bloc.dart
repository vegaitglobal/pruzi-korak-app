import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/domain/leaderboard/leaderboard_model.dart';
import 'package:pruzi_korak/domain/leaderboard/top_three_leaderboard_model.dart';

part 'team_leaderboard_event.dart';
part 'team_leaderboard_state.dart';

class TeamLeaderboardBloc extends Bloc<TeamLeaderboardEvent, TeamLeaderboardState> {
  TeamLeaderboardBloc() : super(TeamLeaderboardLoading()) {
    on<LoadTeamLeaderboard>((event, emit) {
      // TODO: implement event handler

      emit(
        TeamLeaderboardLoaded(
          topThreeLeaderboardModel: topThreeLeaderboardModel,
          leaderboardList: leaderboardList,
        ),
      );
    });

    add(LoadTeamLeaderboard());
  }
  // Models for test purposes
  final topThreeLeaderboardModel = TopThreeLeaderboardModel(
    first: LeaderboardModel(
      id: '1',
      name: 'Marketing Tim',
      steps: '10000',
      rank: '1',
    ),
    second: LeaderboardModel(
      id: '2',
      name: 'Dizajneri',
      steps: '8000',
      rank: '2',
    ),
    third: LeaderboardModel(
      id: '3',
      name: 'Prodaja',
      steps: '6000',
      rank: '3',
    ),
  );

  final leaderboardList = [
    LeaderboardModel(
      id: '4',
      name: 'Dev Tim',
      steps: '4000',
      rank: '4',
    ),
    LeaderboardModel(
      id: '5',
      name: 'HR Tim',
      steps: '5000',
      rank: '5',
    ),
    LeaderboardModel(
      id: '6',
      name: 'Finansije',
      steps: '6000',
      rank: '6',
    ),
    LeaderboardModel(
      id: '7',
      name: 'Logistika',
      steps: '7000',
      rank: '7',
    ),
    LeaderboardModel(
      id: '8',
      name: 'Pravni Tim',
      steps: '8000',
      rank: '8',
    ),
    LeaderboardModel(
      id: '9',
      name: 'Korisnička podrška',
      steps: '9000',
      rank: '9',
    ),
    LeaderboardModel(
      id: '10',
      name: 'Menadžment',
      steps: '10000',
      rank: '10',
    ),
    LeaderboardModel(
      id: '11',
      name: 'IT Sektor',
      steps: '11000',
      rank: '11',
    ),
    LeaderboardModel(
      id: '12',
      name: 'Nabavka',
      steps: '12000',
      rank: '12',
    ),
    LeaderboardModel(
      id: '13',
      name: 'Operacije',
      steps: '13000',
      rank: '13',
    ),
    LeaderboardModel(
      id: '14',
      name: 'Analitika',
      steps: '14000',
      rank: '14',
    ),
  ];
}
