import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/data/leaderboard/leaderboard_repository.dart';
import 'package:pruzi_korak/domain/leaderboard/leaderboard_model.dart';
import 'package:pruzi_korak/domain/leaderboard/top_three_leaderboard_model.dart';

part 'team_leaderboard_event.dart';

part 'team_leaderboard_state.dart';

class TeamLeaderboardBloc
    extends Bloc<TeamLeaderboardEvent, TeamLeaderboardState> {
final LeaderboardRepository leaderboardRepository;

  TeamLeaderboardBloc(this.leaderboardRepository) : super(TeamLeaderboardLoading()) {
    on<LoadTeamLeaderboard>((event, emit) async {
      // TODO: implement event handler
      try {
        final response = await leaderboardRepository.getUsersLeaderboard();
        emit(
          TeamLeaderboardLoaded(
            topThreeLeaderboardModel: response.topThree,
            leaderboardList: response.list,
          ),
        );
      } catch (e) {
        emit(TeamLeaderboardError());
      }
    });

    add(LoadTeamLeaderboard());
  }
}
