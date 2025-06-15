import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/core/utils/app_logger.dart';
import 'package:pruzi_korak/data/local/local_storage.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AppLocalStorage _localStorage;

  ProfileBloc(this._localStorage) : super(ProfileInitial()) {
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

    on<ProfileLogOut>((event, emit) {
      // Handle  logic
      emit(ProfileLogoutPressed());
    });

    on<ProfileDeleteAccount>((event, emit) {
      // Handle delete account logic
      emit(ProfileDeleted());
    });

    add(ProfileLoad());
  }
}
