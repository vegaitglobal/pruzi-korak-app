import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

import 'foreground_sync_ticker.dart';

class HealthNativeEvents {
  HealthNativeEvents._();
  static final instance = HealthNativeEvents._();

  static const _channel = MethodChannel('org.pruziKorak.healthkit/callback');

  final _controller = StreamController<void>.broadcast();
  Stream<void> get syncSignals => _controller.stream;

  bool _installed = false;
  ForegroundSyncTicker? _androidTicker;

  Future<void> install() async {
     if(Platform.isAndroid) {
        await installAndroid();
     } else {
        await installIOS();
     }
  }

  Future<void> installAndroid() async {
    if (_installed) return;
    _installed = true;

    _androidTicker = ForegroundSyncTicker(
      interval: const Duration(seconds: 15), // TODO: Adjust interval as needed
      onTick: () {
        _controller.add(null);
      },
      fireImmediately: false,
    )..start();
  }

  Future<void> installIOS() async {
    if (_installed) return;
    _installed = true;

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'stepCountChanged') {
        _controller.add(null);
      }
    });
  }

  Future<void> dispose() async {
    _androidTicker?.dispose();
    _androidTicker = null;
    await _controller.close();
  }
}