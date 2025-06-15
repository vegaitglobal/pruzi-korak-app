import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/core/constants/app_constants.dart';
import 'package:pruzi_korak/domain/leaderboard/leaderboard_model.dart';
import 'package:pruzi_korak/domain/leaderboard/top_three_leaderboard_model.dart';
import 'package:pruzi_korak/domain/user/steps_model.dart';

part 'user_leaderboard_event.dart';

part 'user_leaderboard_state.dart';

class UserLeaderboardBloc
    extends Bloc<UserLeaderboardEvent, UserLeaderboardState> {
  UserLeaderboardBloc() : super(UserLeaderboardLoading()) {
    on<UserLeaderboardEvent>((event, emit) {

      emit(
        UserLeaderboardLoaded(
          topThreeLeaderboardModel: topThreeLeaderboardModel,
          leaderboardList: leaderboardList,
        ),
      );
    });

    add(LoadUserLeaderboard());
  }

  // Models for test purposes
  final topThreeLeaderboardModel = TopThreeLeaderboardModel(
    first: LeaderboardModel(
      id: '1',
      name: 'User 1',
      steps: '10000',
      rank: '1',
      imageUrl: AppConstants.TEST_IMAGE,
    ),
    second: LeaderboardModel(
      id: '2',
      name: 'User 2',
      steps: '8000',
      rank: '2',
      imageUrl: AppConstants.TEST_IMAGE,
    ),
    third: LeaderboardModel(
      id: '3',
      name: 'User 3',
      steps: '6000',
      rank: '3',
      imageUrl: AppConstants.TEST_IMAGE,
    ),
  );

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
    LeaderboardModel(
      id: '10',
      name: 'User 10',
      steps: '10000',
      rank: '10',
      imageUrl: AppConstants.TEST_IMAGE,
    ),
    LeaderboardModel(
      id: '11',
      name: 'User 11',
      steps: '11000',
      rank: '11',
      imageUrl: AppConstants.TEST_IMAGE,
    ),
    LeaderboardModel(
      id: '12',
      name: 'User 12',
      steps: '12000',
      rank: '12',
      imageUrl: AppConstants.TEST_IMAGE,
    ),
    LeaderboardModel(
      id: '13',
      name: 'User 13',
      steps: '13000',
      rank: '13',
      imageUrl: AppConstants.TEST_IMAGE,
    ),
    LeaderboardModel(
      id: '14',
      name: 'User 14',
      steps: '14000',
      rank: '14',
      imageUrl: AppConstants.TEST_IMAGE,
    ),
  ];
}
