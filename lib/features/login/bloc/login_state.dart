part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();
}

final class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class Loading extends LoginState {
  const Loading();

  @override
  List<Object?> get props => [];
}

class LoginSuccess extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginFailure extends LoginState {
  final String errorMessage;

  const LoginFailure(this.errorMessage);

  @override
  List<Object?> get props => [];
}
