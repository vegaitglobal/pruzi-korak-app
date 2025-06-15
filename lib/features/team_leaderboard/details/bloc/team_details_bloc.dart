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
        (sum, item) => sum + int.parse(item.distance),
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
      id: '7',
      teamName: 'User 7',
      distance: '7000',
      rank: '7',
      imageUrl: AppConstants.TEST_IMAGE, firstName: '', lastName: '',
    ),
    LeaderboardModel(
      id: '8',
      teamName: 'User 8',
      distance: '8000',
      rank: '8',
      imageUrl: AppConstants.TEST_IMAGE, firstName: '', lastName: '',
    ),
    LeaderboardModel(
      id: '9',
      teamName: 'User 9',
      distance: '9000',
      rank: '9',
      imageUrl: AppConstants.TEST_IMAGE, firstName: '', lastName: '',
    ),
  ];
}
