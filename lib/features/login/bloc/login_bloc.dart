import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/domain/auth/AuthRepository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc(this._authRepository) : super(LoginInitial()) {
    on<LoginUser>((event, emit) {
      onLoginUserEvent(event, emit);
    });
  }

  void onLoginUserEvent(LoginUser event, Emitter<LoginState> emitter) async {
    emitter(Loading());
    try {
      _validateUserCredentialsInput(event);

      final loginResponse = await _authRepository.login(
        event.email,
        event.password,
      );

      emitter(LoginSuccess());
    } on LoginInputValidationException catch (e) {
      // print(
      //   "=====>>> error ${e} occurred while attempting login operation for"
      //   " email ${event.email}"
      //   " with password ${event.password}",
      // );
      emitter(LoginFailure(e));
    }
  }

  void _validateUserCredentialsInput(LoginUser event) {
    if (event.email.isEmpty || _isEmail(event.email)) {
      throw InvalidEmailException(event.email);
    }

    if (event.password.isEmpty) {
      throw InvalidPasswordException(event.password);
    }
  }

  bool _isEmail(String email) => !RegExp(r'.+@.+').hasMatch(email);
}

class LoginInputValidationException implements Exception {}

class InvalidPasswordException implements LoginInputValidationException {
  final String password;

  const InvalidPasswordException(this.password);
}

class InvalidEmailException implements LoginInputValidationException {
  final String email;

  const InvalidEmailException(this.email);
}
