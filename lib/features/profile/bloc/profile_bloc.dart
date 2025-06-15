import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileLoad>((event, emit) {
      emit(ProfileLoading());
      // TODO: implement event handler

      // Simulate loading user data
      final userModel = UserModel(
        id: '123',
        fullName: 'Nemanja Pajic',
      );
      emit(ProfileLoaded(userModel: userModel));
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
