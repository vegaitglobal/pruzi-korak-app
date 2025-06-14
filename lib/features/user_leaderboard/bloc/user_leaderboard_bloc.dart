import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/domain/user/steps_model.dart';

part 'user_leaderboard_event.dart';
part 'user_leaderboard_state.dart';

class UserLeaderboardBloc extends Bloc<UserLeaderboardEvent, UserLeaderboardState> {
  UserLeaderboardBloc() : super(UserLeaderboardLoading()) {
    on<UserLeaderboardEvent>((event, emit) {
      //   final List<StepsModel> stepsList; Create me this list
        // Simulate loading data
        // Here you would typically fetch the data from a repository or service
        // For demonstration, we will use a mock list of StepsModel
        final stepsList = [
          StepsModel(steps: '1000', totalSteps: '5000'),
          StepsModel(steps: '2000', totalSteps: '5000'),
          StepsModel(steps: '3000', totalSteps: '5000'),
        ];

        emit(UserLeaderboardLoaded(stepsList: stepsList));

    });

    add(LoadUserLeaderboard());
  }
}
