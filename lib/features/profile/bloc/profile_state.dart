part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  final UserModel userModel;

  const ProfileLoaded({required this.userModel});

  @override
  List<Object> get props => [userModel];
}

final class ProfileLoggedOut extends ProfileState {
  const ProfileLoggedOut();
}

final class ProfileDeleted extends ProfileState {
  const ProfileDeleted();
}
