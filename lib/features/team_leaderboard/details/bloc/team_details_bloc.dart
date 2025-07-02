import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/data/leaderboard/leaderboard_repository.dart';
import 'package:pruzi_korak/domain/leaderboard/leaderboard_model.dart';

part 'team_details_event.dart';

part 'team_details_state.dart';

class TeamDetailsBloc extends Bloc<TeamDetailsEvent, TeamDetailsState> {
  final LeaderboardRepository leaderboardRepository;

  TeamDetailsBloc({required this.leaderboardRepository}) : super(TeamDetailsLoading()) {
    on<FetchTeamDetailsEvent>(_onFetchTeamDetails);
  }

  Future<void> _onFetchTeamDetails(
    FetchTeamDetailsEvent event,
    Emitter<TeamDetailsState> emit,
  ) async {
    emit(TeamDetailsLoading());
    try {
      final leaderboardList = await leaderboardRepository.getUsersLeaderboardByTeam(event.teamId);

      if (leaderboardList.isEmpty) {
        emit(TeamDetailsEmpty());
        return;
      }

      final totalDistance = leaderboardList.fold<double>(
        0,
        (sum, item) => sum + (double.tryParse(item.distance) ?? 0),
      );

      emit(
        TeamDetailsLoaded(
          totalDistance: totalDistance.toStringAsFixed(1),
          leaderboardList: leaderboardList,
        ),
      );
    } catch (e) {
      emit(TeamDetailsError());
    }
  }
}
