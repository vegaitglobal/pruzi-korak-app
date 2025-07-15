import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/data/health_data/health_repository.dart';
import 'package:pruzi_korak/data/home/home_repository.dart';
import 'package:pruzi_korak/domain/user/steps_model.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HealthRepository healthRepository;
  final HomeRepository homeRepository;

  HomeBloc(this.homeRepository, {required this.healthRepository})
    : super(HomeLoading()) {
    on<HomeLoadEvent>(_onLoad);
    add(const HomeLoadEvent());
  }

  Future<void> _onLoad(HomeLoadEvent event, Emitter<HomeState> emit) async {
    try {
      final syncData = await healthRepository.fetchSyncInfo();

      final lastSyncAtStr = syncData['last_sync_at'];
      final todayStart = DateTime.now().toLocal();

      final lastSyncAt =
          lastSyncAtStr != null
              ? DateTime.parse(lastSyncAtStr)
              : todayStart;

      final dailyDistances = await healthRepository
          .getDailyDistancesFromLastSync(lastSyncAt);

      if (dailyDistances.isNotEmpty) {
        await healthRepository.sendDailyDistances(dailyDistances);
      }

      final response = await homeRepository.getHomeData();
      final userModel = response.user;
      final teamStepsModel = response.teamUserStats;

      // Fetch user rank
      final myRank = await homeRepository.getMyRank();

      final userStepsModel = StepsModel(
        steps: teamStepsModel.userToday,
        totalSteps: teamStepsModel.userTotal,
      );

      final team = StepsModel(
        steps: teamStepsModel.teamToday,
        totalSteps: teamStepsModel.teamTotal,
      );

      emit(
        HomeLoaded(
          userModel: response.user,
          userStepsModel: userStepsModel,
          teamStepsModel: team,
          myRank: myRank,
        ),
      );
    } catch (_) {
      emit(const HomeError());
    }
  }
}
