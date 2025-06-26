import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/domain/auth/AuthRepository.dart';

part 'splash_event.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository _authRepository;

  SplashBloc(this._authRepository) : super(SplashInitial()) {
    on<CheckUserLoggedIn>((event, emit) async {
      final isUserLoggedIn = await _authRepository.isLoggedIn();
      if (isUserLoggedIn) {
        emit(UserLoggedIn());
      } else {
        emit(UserNotLoggedIn());
      }
    });

    add(CheckUserLoggedIn());
  }
}
