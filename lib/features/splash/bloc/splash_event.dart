part of 'splash_bloc.dart';

sealed class SplashEvent extends Equatable {
  const SplashEvent();
}

final class CheckUserLoggedIn extends SplashEvent {
  const CheckUserLoggedIn();

  @override
  List<Object> get props => [];
}
