import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/core/utils/app_logger.dart';

class SessionStream {
  final _controller = StreamController<SessionEvent>.broadcast();

  Stream<SessionEvent> get stream => _controller.stream;

  void triggerLogout() {
    AppLogger.logDebug("Trigger Logout");
    _controller.add(SessionExpired());
  }

  void dispose() {
    _controller.close();
  }
}

sealed class SessionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class SessionExpired extends SessionEvent {}
