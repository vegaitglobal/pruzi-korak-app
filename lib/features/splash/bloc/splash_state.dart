part of 'splash_bloc.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

final class SplashInitial extends SplashState {
  const SplashInitial();
}

final class UserLoggedIn extends SplashState {
  const UserLoggedIn();
}

final class UserNotLoggedIn extends SplashState {
  const UserNotLoggedIn();
}
