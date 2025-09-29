import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

import '../../domain/health/daily_distance.dart';
import 'bg_flush_cache.dart';

class HealthRepository {
  static const _channel = MethodChannel('org.pruziKorak.healthkit/callback');

  Future<Map<String, String?>> fetchSyncInfo({int maxRetries = 3}) async {
    debugPrint('🔍 Calling sync-info...');
    int retryCount = 0;
    Duration delay = const Duration(seconds: 1);

    while (true) {
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

        retryCount++;
        if (retryCount > maxRetries) {
          debugPrint(
            '❌ Maximum retries ($maxRetries) reached for fetchSyncInfo',
          );
          rethrow;
        }

        debugPrint(
          '⏱️ Retrying fetchSyncInfo ($retryCount/$maxRetries) after ${delay.inMilliseconds}ms',
        );
        await Future.delayed(delay);
        // Exponential backoff: double the delay for next retry
        delay *= 2;
      }
    }
  }

  Future<void> sendDailyDistances(List<DailyDistance> distances) async {
    debugPrint('🔍 Calling sync-daily-distances...');

    // Filter out invalid distances
    final validDistances = distances.where((d) => d.isValid()).toList();

    if (validDistances.isEmpty) {
      debugPrint('📭 No valid distances to sync.');
      return;
    }

    for (final entry in validDistances) {
      debugPrint('📅 Sending: date=${entry.date}, km=${entry.totalKilometers}');
    }

    try {
      final response = await Supabase.instance.client.functions
          .invoke(
            'sync-daily-distances',
            body: {'distances': validDistances.map((d) => d.toJson()).toList()},
          )
          .timeout(
            const Duration(seconds: 5),
            onTimeout:
                () => throw TimeoutException('Supabase function timed out'),
          );

      debugPrint('📬 Response received: status=${response.status}');

      await BgFlushCache.clearToday();

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
    // Don't send if kilometers is zero or negative
    if (kilometers <= 0.0) {
      debugPrint(
        '⚠️ Skipping sync-today-distances: invalid value ($kilometers km)',
      );
      return;
    }

    debugPrint('📤 Calling sync-today-distances with $kilometers km...');

    try {
      final response = await Supabase.instance.client.functions
          .invoke('sync-today-distances', body: {'kilometers': kilometers})
          .timeout(const Duration(seconds: 3));

      await BgFlushCache.clearToday();

      debugPrint('📬 Response received: status=${response.status}');

      if (response.status != 200) {
        debugPrint('❌ sync-today-distances failed: ${response.data}');
        throw Exception('sync-today-distances failed: ${response.data}');
      }

      debugPrint('✅ sync-today-distances success: $kilometers km');
    } catch (e, stack) {
      debugPrint('❌ sendTodayDistance error: $e');
      debugPrint('🪵 $stack');
    }
  }

  // MARK: - Fetch raw kilometers
  Future<double> getKilometersFromCampaignStart(DateTime campaignStart) async {
    try {
      final timestamp = campaignStart.millisecondsSinceEpoch / 1000;
      final kilometers = await _channel.invokeMethod<double>(
        'getKilometersFromCampaignStart',
        timestamp,
      );
      return kilometers ?? 0;
    } catch (e, stack) {
      debugPrint('❌ Error in getKilometersFromCampaignStart: $e');
      debugPrint('StackTrace: $stack');
      return 0;
    }
  }

  Future<List<DailyDistance>> getDailyKilometersFromLastSync(
    DateTime lastSync,
  ) async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>(
        'getKilometersGroupedByDay',
        lastSync.millisecondsSinceEpoch / 1000,
      );

      final rawData =
          result?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [];
      return rawData.map((data) => DailyDistance.fromJson(data)).toList();
    } catch (e, stack) {
      debugPrint('❌ Error in getDailyKilometersFromLastSync: $e');
      debugPrint('$stack');
      return [];
    }
  }

  Future<double> getTodayKilometersSinceLastSync(DateTime timestamp) async {
    try {
      final seconds = timestamp.millisecondsSinceEpoch / 1000;
      final kilometers = await _channel.invokeMethod<double>(
        'getTodayKilometersSinceLastSync',
        seconds,
      );
      return kilometers ?? 0;
    } catch (e, stack) {
      debugPrint('❌ Error in getTodayKilometersSinceLastSync: $e');
      debugPrint('StackTrace: $stack');
      return 0;
    }
  }

  // MARK: - Fetch steps (Currently unused)
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

  Future<List<DailyDistance>> getDailyDistancesFromLastSync(
    DateTime lastSync,
  ) async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>(
        'getStepsGroupedByDay',
        lastSync.millisecondsSinceEpoch / 1000,
      );

      final rawData =
          result?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [];
      return rawData.map((data) => DailyDistance.fromJson(data)).toList();
    } catch (e, stack) {
      debugPrint('❌ Error in getDailyDistancesFromLastSync: $e');
      debugPrint('$stack');
      return [];
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

      return kilometers;
    } catch (e, stack) {
      debugPrint('❌ Error in getTodayDistanceSinceLastSync: $e');
      debugPrint('StackTrace: $stack');
      return 0;
    }
  }
}
