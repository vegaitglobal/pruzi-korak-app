import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/core/constants/app_constants.dart';
import 'package:pruzi_korak/data/leaderboard/leaderboard_repository.dart';
import 'package:pruzi_korak/domain/leaderboard/leaderboard_model.dart';
import 'package:pruzi_korak/domain/leaderboard/top_three_leaderboard_model.dart';
import 'package:pruzi_korak/domain/user/steps_model.dart';

part 'user_leaderboard_event.dart';

part 'user_leaderboard_state.dart';

class UserLeaderboardBloc
    extends Bloc<UserLeaderboardEvent, UserLeaderboardState> {
  final LeaderboardRepository leaderboardRepository;

  UserLeaderboardBloc(this.leaderboardRepository)
    : super(UserLeaderboardLoading()) {
    on<UserLeaderboardEvent>((event, emit) async {
      try {
        final response = await leaderboardRepository.getUsersLeaderboard();
        emit(
          UserLeaderboardLoaded(
            topThreeLeaderboardModel: response.topThree,
            leaderboardList: response.list,
          ),
        );
      } catch (e) {
        emit(UserLeaderboardError());
      }
    });

    add(LoadUserLeaderboard());
  }
}
