part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginUser extends LoginEvent {
  final String email;
  final String password;

  const LoginUser(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}