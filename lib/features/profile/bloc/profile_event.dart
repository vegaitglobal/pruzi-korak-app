part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}

final class ProfileLoad extends ProfileEvent {
  const ProfileLoad();

  @override
  List<Object> get props => [];
}

final class ProfileLogOut extends ProfileEvent {
  const ProfileLogOut();

  @override
  List<Object> get props => [];
}

final class ProfileDeleteAccount extends ProfileEvent {
  const ProfileDeleteAccount();

  @override
  List<Object> get props => [];
}

