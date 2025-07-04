import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/app/di/injector.dart';
import 'package:pruzi_korak/core/events/login_notification_event.dart';
import 'package:pruzi_korak/core/utils/app_logger.dart';
import 'package:pruzi_korak/data/local/local_storage.dart';
import 'package:pruzi_korak/domain/auth/AuthRepository.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AppLocalStorage _localStorage;
  final AuthRepository _authRepository;

  ProfileBloc(this._localStorage, this._authRepository)
    : super(ProfileInitial()) {
    on<ProfileLoad>((event, emit) async {
      emit(ProfileLoading());

      try {
        final userModel = await _localStorage.getUser();

        emit(
          ProfileLoaded(
            userModel:
                userModel ??
                UserModel(fistName: "", lastName: "", teamName: ""),
          ),
        );
      } catch (e) {
        AppLogger.logWarning('Error loading profile: $e');
      }
    });

    on<ProfileLogOut>((event, emit) async {
      try {
        await _authRepository.logout();

        // Notify that user has logged out to reset notification scheduling state
        getIt<LoginNotificationEvent>().notifyLogout();

        emit(ProfileLoggedOut());
      } catch (e) {
        AppLogger.logError('Error during logout: $e');
      }
    });

    on<ProfileDeleteAccount>((event, emit) {
      // Handle delete account logic
      emit(ProfileDeleted());
    });

    add(ProfileLoad());
  }
}
