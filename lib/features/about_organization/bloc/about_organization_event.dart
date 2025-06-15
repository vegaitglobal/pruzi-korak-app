part of 'about_organization_bloc.dart';

sealed class AboutOrganizationEvent extends Equatable {
  const AboutOrganizationEvent();
}

final class AboutOrganizationLoad extends AboutOrganizationEvent {
  const AboutOrganizationLoad();

  @override
  List<Object> get props => [];
}
