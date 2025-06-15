import 'dart:io';
import 'package:flutter/services.dart';
import 'package:health/health.dart';

class HealthRepository {
  static const _channel = MethodChannel('org.pruziKorak.healthkit/callback');

  final Health _health = Health();

  Future<double> getStepsToday() async {
    if (Platform.isIOS) {
      return _fetchStepsFromNativeToday();
    } else {
      return _fetchStepsFromPluginToday();
    }
  }

  Future<double> getStepsFromCampaignStart(DateTime campaignStart) async {
    if (Platform.isIOS) {
      return _fetchStepsFromNativeCampaignStart(campaignStart);
    } else {
      return _fetchStepsFromPluginCampaignStart(campaignStart);
    }
  }

  Future<double> _fetchStepsFromNativeToday() async {
    try {
      final steps = await _channel.invokeMethod<double>('getStepsToday');
      return steps ?? 0;
    } catch (e) {
      throw Exception('iOS: Failed to fetch steps today: $e');
    }
  }

  Future<double> _fetchStepsFromNativeCampaignStart(DateTime campaignStart) async {
    try {
      final timestamp = campaignStart.millisecondsSinceEpoch / 1000;
      final steps = await _channel.invokeMethod<double>('getStepsFromCampaignStart', timestamp);
      return steps ?? 0;
    } catch (e) {
      throw Exception('iOS: Failed to fetch steps from campaign start: $e');
    }
  }

  Future<double> _fetchStepsFromPluginToday() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    return _fetchStepsFromPlugin(midnight, now);
  }

  Future<double> _fetchStepsFromPluginCampaignStart(DateTime start) async {
    final now = DateTime.now();
    return _fetchStepsFromPlugin(start, now);
  }

  Future<double> _fetchStepsFromPlugin(DateTime start, DateTime end) async {
    final types = [HealthDataType.STEPS];

    final hasPermissions = await _health.requestAuthorization(types);

    if (!hasPermissions) {
      throw Exception('Android: Authorization not granted for steps.');
    }

    final data = await _health.getHealthDataFromTypes(
      types: [HealthDataType.STEPS],
      startTime: start,
      endTime: end,
    );
    final total = data.fold<double>(0, (sum, d) => sum + (d.value as num));

    return total;
  }
}