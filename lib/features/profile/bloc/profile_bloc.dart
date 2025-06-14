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
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbq96YIIrnntPV81dxzOoheWk0sTyet_FYPw&s',
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
