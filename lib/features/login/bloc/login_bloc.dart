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
    if (event.password.isEmpty || event.email.isEmpty) {
      throw Exception("invalidni argumenti");
    }

    emitter(Loading());
    print("=====>>> perform login");
    try {
      final loginEventResults = await _authRepository.login(
        event.email,
        event.password,
      );
      print("=====>>> on success $loginEventResults");
      emitter(LoginSuccess());
    } on Exception catch (e) {
      print(
        "=====>>> error ${e} occurred while attempting login operation for"
        " email ${event.email}"
        " with password ${event.password}",
      );
      emitter(LoginFailure(_getErrorFromException(e)));
    }
  }

  //TODO parse exception into error string
  String _getErrorFromException(Exception e) => "Desila se greska";
}
