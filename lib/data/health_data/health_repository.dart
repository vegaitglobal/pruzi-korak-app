import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HealthRepository {
  static const _channel = MethodChannel('org.pruziKorak.healthkit/callback');

  Future<double> getStepsToday() async {
  try {
    final steps = await _channel.invokeMethod<double>('getStepsToday');
    return steps ?? 0;
  } catch (e, stack) {
    debugPrint('❌ Error in getStepsToday: $e');
    debugPrint('StackTrace: $stack');
    return 0;
  }
}

  Future<double> getStepsFromCampaignStart(DateTime campaignStart) async {
    try {
      final timestamp = campaignStart.millisecondsSinceEpoch / 1000;
      final steps = await _channel.invokeMethod<double>('getStepsFromCampaignStart', timestamp);
      return steps ?? 0;
    } catch (e, stack) {
      debugPrint('❌ Error in getStepsFromCampaignStart: $e');
      debugPrint('StackTrace: $stack');
      return 0;
    }
  }
}