import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/app/di/injector.dart';
import 'package:pruzi_korak/core/events/login_notification_event.dart';
import 'package:pruzi_korak/core/utils/app_logger.dart';
import 'package:pruzi_korak/data/local/local_storage.dart';
import 'package:pruzi_korak/data/profile/profile_repository.dart';
import 'package:pruzi_korak/domain/auth/auth_repository.dart';
import 'package:pruzi_korak/domain/profile/user_rank_model.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  final AppLocalStorage _localStorage;
  final AuthRepository _authRepository;

  ProfileBloc(this._profileRepository, this._localStorage, this._authRepository)
    : super(ProfileInitial()) {
    on<ProfileLoad>((event, emit) async {
      emit(ProfileLoading());

      try {
        final userModel = await _localStorage.getUser();
        final userRanks = await _profileRepository.getUserRanks();

        emit(
          ProfileLoaded(
            userModel:
                userModel ??
                UserModel(fistName: "", lastName: "", teamName: ""),
            userRankModel: userRanks,
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
