import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

import 'bg_flush_cache.dart';

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
      final steps = await _channel.invokeMethod<double>(
        'getStepsFromCampaignStart',
        timestamp,
      );
      return steps ?? 0;
    } catch (e, stack) {
      debugPrint('❌ Error in getStepsFromCampaignStart: $e');
      debugPrint('StackTrace: $stack');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getDailyDistancesFromLastSync(
    DateTime lastSync,
  ) async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>(
        'getStepsGroupedByDay',
        lastSync.millisecondsSinceEpoch / 1000,
      );
      return result?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [];
    } catch (e, stack) {
      debugPrint('❌ Error in getDailyDistancesFromLastSync: $e');
      debugPrint('$stack');
      return [];
    }
  }

  Future<Map<String, String?>> fetchSyncInfo() async {
    debugPrint('🔍 Calling sync-info...');
    try {
      final response = await Supabase.instance.client.functions
          .invoke('sync-info')
          .timeout(
            const Duration(seconds: 5),
            onTimeout:
                () => throw TimeoutException('Supabase function timed out'),
          );

      debugPrint('📬 Response received: ${response.status}');

      if (response.status != 200) {
        debugPrint('❌ Failed with: ${response.data}');
        throw Exception('Failed to fetch sync info: ${response.data}');
      }

      final data = response.data as Map<String, dynamic>;

      final lastSyncAt = data['last_sync_at'] as String?;
      final lastSignInAt = data['last_sign_in_at'] as String?;

      debugPrint('✅ Last sync: $lastSyncAt');
      debugPrint('✅ Last sign in: $lastSignInAt');

      return {'last_sync_at': lastSyncAt, 'last_sign_in_at': lastSignInAt};
    } catch (e, stack) {
      debugPrint('❌ fetchSyncInfo error: $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  Future<void> sendDailyDistances(List<Map<String, dynamic>> distances) async {
    debugPrint('🔍 Calling sync-daily-distances...');

    if (distances.isEmpty) {
      debugPrint('📭 No distances to sync.');
      return;
    }

    for (final entry in distances) {
      debugPrint(
        '📅 Sending: date=${entry['date']}, km=${entry['total_kilometers']}',
      );
    }

    try {
      final response = await Supabase.instance.client.functions
          .invoke('sync-daily-distances', body: {'distances': distances})
          .timeout(
            const Duration(seconds: 5),
            onTimeout:
                () => throw TimeoutException('Supabase function timed out'),
          );

      debugPrint('📬 Response received: status=${response.status}');

      if (response.status != 200) {
        debugPrint(
          '❌ sendDailyDistances error: ${response.status}: ${response.data}',
        );
        throw Exception('Failed to sync distances: ${response.data}');
      }

      debugPrint('✅ sendDailyDistances success: ${response.data}');
    } catch (e, stack) {
      debugPrint('❌ sendDailyDistances exception: $e');
      debugPrint('🪵 $stack');
    }
  }

  Future<void> sendTodayDistance(double kilometers) async {
    debugPrint('📤 Calling sync-today-distances with $kilometers km...');

    try {
      await BgFlushCache.saveToday(kilometers);

      final response = await Supabase.instance.client.functions
          .invoke('sync-today-distances', body: {'kilometers': kilometers})
          .timeout(const Duration(seconds: 3));

      debugPrint('📬 Response received: status=${response.status}');

      if (response.status != 200) {
        await BgFlushCache.clearToday();
        debugPrint('❌ sync-today-distances failed: ${response.data}');
        throw Exception('sync-today-distances failed: ${response.data}');
      }

      debugPrint('✅ sync-today-distances success: $kilometers km');
    } catch (e, stack) {
      debugPrint('❌ sendTodayDistance error: $e');
      debugPrint('🪵 $stack');
    }
  }

  Future<double> getTodayDistanceSinceLastSync(DateTime timestamp) async {
    try {
      final seconds = timestamp.millisecondsSinceEpoch / 1000;
      final steps = await _channel.invokeMethod<double>(
        'getTodayStepsSinceLastSync',
        seconds,
      );
      final kilometers = (steps ?? 0) / 1300.0;

      await BgFlushCache.saveToday(kilometers);

      return kilometers;
    } catch (e, stack) {
      debugPrint('❌ Error in getTodayDistanceSinceLastSync: $e');
      debugPrint('StackTrace: $stack');
      return 0;
    }
  }
}
