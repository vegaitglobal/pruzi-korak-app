import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/data/health_data/health_repository.dart';
import 'package:pruzi_korak/domain/user/steps_model.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HealthRepository healthRepository;
  final DateTime campaignStart = DateTime(2024, 6, 13);

  HomeBloc({required this.healthRepository}) : super(HomeLoading()) {
    on<HomeLoadEvent>(_onLoad);
    add(const HomeLoadEvent());
  }

  Future<void> _onLoad(HomeLoadEvent event, Emitter<HomeState> emit) async {
    try {
      final userModel = UserModel(
        id: "1",
        fullName: "Nemanja\nPajic",
        imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbq96YIIrnntPV81dxzOoheWk0sTyet_FYPw&s",
      );

      final stepsToday = await healthRepository.getStepsToday();
      final stepsSinceStart = await healthRepository.getStepsFromCampaignStart(campaignStart);

      final userStepsModel = StepsModel(
        steps: stepsToday.toStringAsFixed(0),
        totalSteps: stepsSinceStart.toStringAsFixed(0),
      );

      final teamStepsModel = StepsModel(steps: '20000', totalSteps: '50000');

      emit(HomeLoaded(
        userModel: userModel,
        userStepsModel: userStepsModel,
        teamStepsModel: teamStepsModel,
      ));
    } catch (_) {
      emit(const HomeError());
    }
  }
}