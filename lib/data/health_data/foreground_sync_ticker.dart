import 'dart:async';
import 'package:flutter/widgets.dart';

class ForegroundSyncTicker with WidgetsBindingObserver {
  ForegroundSyncTicker({
    required Duration interval,
    required void Function() onTick,
    bool fireImmediately = true,
  })  : _interval = interval,
        _onTick = onTick,
        _fireImmediately = fireImmediately;

  final Duration _interval;
  final void Function() _onTick;
  final bool _fireImmediately;

  Timer? _timer;
  bool _started = false;

  void start() {
    if (_started) return;
    _started = true;

    WidgetsBinding.instance.addObserver(this);

    final life = WidgetsBinding.instance.lifecycleState;
    if (life == AppLifecycleState.resumed) {
      _startTimer();
    }
  }

  void stop() {
    if (!_started) return;
    _started = false;

    WidgetsBinding.instance.removeObserver(this);
    _stopTimer();
  }

  void dispose() {
    stop();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  void _startTimer() {
    if (_timer != null) return;

    if (_fireImmediately) {
      _onTick();
    }

    _timer = Timer.periodic(_interval, (_) {
      _onTick();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
