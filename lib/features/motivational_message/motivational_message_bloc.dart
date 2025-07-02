import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/domain/user/motivational_message.dart';
import 'package:pruzi_korak/data/user_content/user_content_repository.dart';

part 'motivational_message_event.dart';
part 'motivational_message_state.dart';

class MotivationalMessageBloc extends Bloc<MotivationalMessageEvent, MotivationalMessageState> {
  final UserContentRepository repository;

  MotivationalMessageBloc(this.repository) : super(MotivationalMessageLoading()) {
    on<MotivationalMessageLoadEvent>(_onLoad);
    add(const MotivationalMessageLoadEvent());
  }

  Future<void> _onLoad(
    MotivationalMessageLoadEvent event,
    Emitter<MotivationalMessageState> emit,
  ) async {
    emit(MotivationalMessageLoading());
    try {
      final message = await repository.getMyDailyMotivation();
      if (message != null) {
        emit(MotivationalMessageLoaded(message));
      } else {
        emit(const MotivationalMessageError());
      }
    } catch (_) {
      emit(const MotivationalMessageError());
    }
  }
}
