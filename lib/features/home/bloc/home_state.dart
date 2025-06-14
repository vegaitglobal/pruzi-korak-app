part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeLoading extends HomeState {
  @override
  List<Object> get props => [];
}

final class HomeLoaded extends HomeState {
  final UserModel userModel;
  final StepsModel userStepsModel;
  final StepsModel teamStepsModel;

  const HomeLoaded({
    required this.userModel,
    required this.userStepsModel,
    required this.teamStepsModel,
  });

  @override
  List<Object> get props => [userModel, userStepsModel, teamStepsModel];
}

final class HomeError extends HomeState {
  const HomeError();
}
