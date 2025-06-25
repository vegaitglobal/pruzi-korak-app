import 'dart:async';

/// This class handles notification events related to login actions.
/// It uses a simple stream to allow communication between Login feature and app-level components.
class LoginNotificationEvent {
  final StreamController<LoginEvent> _controller = StreamController<LoginEvent>.broadcast();

  /// Stream that emits login events
  Stream<LoginEvent> get stream => _controller.stream;

  /// Notifies listeners that a login was successful and notifications should be scheduled
  void notifyLoginSuccess() {
    _controller.add(LoginEvent.loginSuccess);
  }

  /// Dispose of the stream controller when no longer needed
  void dispose() {
    _controller.close();
  }
}

/// Login events that can be dispatched
enum LoginEvent {
  loginSuccess,
}
