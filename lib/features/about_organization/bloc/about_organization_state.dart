part of 'about_organization_bloc.dart';

sealed class AboutOrganizationState extends Equatable {
  const AboutOrganizationState();

  @override
  List<Object> get props => [];
}

final class AboutOrganizationInitial extends AboutOrganizationState {
  const AboutOrganizationInitial();
}

final class AboutOrganizationLoading extends AboutOrganizationState {
  const AboutOrganizationLoading();
}

final class AboutOrganizationLoaded extends AboutOrganizationState {
  final OrganizationModel organization;

  const AboutOrganizationLoaded({required this.organization});

  @override
  List<Object> get props => [organization];
}

final class AboutOrganizationError extends AboutOrganizationState {
  const AboutOrganizationError();
}
