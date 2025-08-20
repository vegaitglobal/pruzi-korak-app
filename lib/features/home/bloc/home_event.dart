part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeLoadEvent extends HomeEvent {
  const HomeLoadEvent();

  @override
  List<Object?> get props => [];
}

class HomeSilentUpdateEvent extends HomeEvent {
  const HomeSilentUpdateEvent();

  @override
  List<Object?> get props => [];
}
