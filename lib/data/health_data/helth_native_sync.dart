
import 'dart:async';
import 'package:flutter/services.dart';

class HealthNativeEvents {
  HealthNativeEvents._();
  static final instance = HealthNativeEvents._();

  static const _channel = MethodChannel('org.pruziKorak.healthkit/callback');

  final _controller = StreamController<double>.broadcast();
  Stream<double> get kmDeltas => _controller.stream;

  bool _installed = false;

  Future<void> install() async {
    if (_installed) return;
    _installed = true;

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'stepCountChanged') {
        final deltaKm = (call.arguments as num?)?.toDouble() ?? 0.0;
        _controller.add(deltaKm);
      }
    });

    await _channel.invokeMethod('startStepListener');
  }

  Future<void> dispose() async {
    await _channel.invokeMethod('stopStepListener');
    await _controller.close();
  }
}