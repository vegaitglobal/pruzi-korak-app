part of 'motivational_message_bloc.dart';

sealed class MotivationalMessageState extends Equatable {
  const MotivationalMessageState();

  @override
  List<Object?> get props => [];
}

final class MotivationalMessageLoading extends MotivationalMessageState {}

final class MotivationalMessageLoaded extends MotivationalMessageState {
  final MotivationalMessage message;

  const MotivationalMessageLoaded(this.message);

  @override
  List<Object?> get props => [message];
}

final class MotivationalMessageError extends MotivationalMessageState {
  const MotivationalMessageError();
}
