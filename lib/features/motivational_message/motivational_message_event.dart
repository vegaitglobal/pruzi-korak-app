part of 'motivational_message_bloc.dart';

sealed class MotivationalMessageEvent extends Equatable {
  const MotivationalMessageEvent();

  @override
  List<Object?> get props => [];
}

class MotivationalMessageLoadEvent extends MotivationalMessageEvent {
  const MotivationalMessageLoadEvent();
}
