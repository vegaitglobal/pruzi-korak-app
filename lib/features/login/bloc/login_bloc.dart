import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/domain/auth/AuthRepository.dart';

import '../../../core/utils/app_logger.dart';

part 'login_event.dart';

part 'login_state.dart';

const String _EMAIL =
    r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])'
    r'|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc(this._authRepository) : super(LoginInitial()) {
    on<LoginUser>((event, emit) async {
      emit(Loading());
      var loginState = await onLoginUserEvent(event);
      emit(loginState);
    });
  }

  Future<LoginState> onLoginUserEvent(LoginUser event) async {
    try {
      _validateUserCredentialsInput(event);
      var response = await _authRepository.login(event.email, event.password);
      return LoginSuccess();
    } on LoginInputValidationException catch (e) {
      return LoginFailure(e);
    } on Exception catch (exception) {
      AppLogger.logError("p", exception);
      return LoginFailure(null);
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

  bool _isEmail(String email) => !RegExp(_EMAIL).hasMatch(email);
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
