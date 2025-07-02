import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/data/permissions/permissions_service.dart';
import 'package:pruzi_korak/domain/auth/AuthRepository.dart';

part 'splash_event.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository _authRepository;
  final PermissionsService _permissionsService;

  SplashBloc(this._authRepository, this._permissionsService) : super(SplashInitial()) {
    on<CheckUserLoggedIn>((event, emit) async {
      // Request permissions at app start
      final permissionsResult = await _permissionsService.requestAllPermissions();

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
