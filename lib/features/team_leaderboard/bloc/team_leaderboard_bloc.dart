import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/domain/leaderboard/leaderboard_model.dart';

part 'team_leaderboard_event.dart';
part 'team_leaderboard_state.dart';

class TeamLeaderboardBloc extends Bloc<TeamLeaderboardEvent, TeamLeaderboardState> {
  TeamLeaderboardBloc() : super(TeamLeaderboardInitial()) {
    on<TeamLeaderboardEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
