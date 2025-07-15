part of 'about_pruzi_korak_bloc.dart';

sealed class AboutPruziKorakState extends Equatable {
  const AboutPruziKorakState();

  @override
  List<Object> get props => [];
}

final class AboutPruziKorakInitial extends AboutPruziKorakState {
  const AboutPruziKorakInitial();
}

final class AboutPruziKorakLoading extends AboutPruziKorakState {
  const AboutPruziKorakLoading();
}

final class AboutPruziKorakLoaded extends AboutPruziKorakState {
  final OrganizationModel organization;

  const AboutPruziKorakLoaded({required this.organization});

  @override
  List<Object> get props => [organization];
}

final class AboutPruziKorakError extends AboutPruziKorakState {
  const AboutPruziKorakError();
}
