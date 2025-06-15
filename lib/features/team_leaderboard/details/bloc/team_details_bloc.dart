import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/core/constants/app_constants.dart';
import 'package:pruzi_korak/domain/leaderboard/leaderboard_model.dart';

part 'team_details_event.dart';

part 'team_details_state.dart';

class TeamDetailsBloc extends Bloc<TeamDetailsEvent, TeamDetailsState> {
  TeamDetailsBloc() : super(TeamDetailsLoading()) {
    on<FetchTeamDetailsEvent>((event, emit) {

      final totalDistance = leaderboardList.fold<int>(
        0,
        (sum, item) => sum + int.parse(item.steps),
      );
      emit(
        TeamDetailsLoaded(
          totalDistance: totalDistance.toString(),
          leaderboardList: leaderboardList,
        ),
      );
    });
  }

  final leaderboardList = [
    LeaderboardModel(
      id: '4',
      name: 'User 4',
      steps: '4000',
      rank: '4',
      imageUrl: AppConstants.TEST_IMAGE,
    ),
    LeaderboardModel(
      id: '5',
      name: 'User 5',
      steps: '5000',
      rank: '5',
      imageUrl: AppConstants.TEST_IMAGE,
    ),
    LeaderboardModel(
      id: '6',
      name: 'User 6',
      steps: '6000',
      rank: '6',
      imageUrl: AppConstants.TEST_IMAGE,
    ),
    LeaderboardModel(
      id: '7',
      name: 'User 7',
      steps: '7000',
      rank: '7',
      imageUrl: AppConstants.TEST_IMAGE,
    ),
    LeaderboardModel(
      id: '8',
      name: 'User 8',
      steps: '8000',
      rank: '8',
      imageUrl: AppConstants.TEST_IMAGE,
    ),
    LeaderboardModel(
      id: '9',
      name: 'User 9',
      steps: '9000',
      rank: '9',
      imageUrl: AppConstants.TEST_IMAGE,
    ),
  ];
}
