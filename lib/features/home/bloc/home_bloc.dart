import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/domain/user/steps_model.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading()) {
    on<HomeLoadEvent>((event, emit) async {
      // delay await
      await Future.delayed(const Duration(seconds: 2));

      // Simulate fetching user and team user data
      final userModel = UserModel(id: "1", fullName: "Nemanja\nPajic", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbq96YIIrnntPV81dxzOoheWk0sTyet_FYPw&s");
      final userStepsModel = StepsModel(steps: '5000', totalSteps: '10000');
      final teamStepsModel = StepsModel(steps: '20000', totalSteps: '50000');

      // Emit the loaded state with the fetched data
      emit(
        HomeLoaded(
          userModel: userModel,
          userStepsModel: userStepsModel,
          teamStepsModel: teamStepsModel,
        ),
      );
    });

    add(HomeLoadEvent());
  }
}
