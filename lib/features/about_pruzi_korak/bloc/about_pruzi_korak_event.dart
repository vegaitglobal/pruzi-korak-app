part of 'about_pruzi_korak_bloc.dart';

sealed class AboutPruziKorakEvent extends Equatable {
  const AboutPruziKorakEvent();
}

final class AboutPruziKorakLoad extends AboutPruziKorakEvent {
  const AboutPruziKorakLoad();

  @override
  List<Object> get props => [];
}
