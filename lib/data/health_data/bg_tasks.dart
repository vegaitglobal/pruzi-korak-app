// lib/core/bg/bg_tasks.dart
import 'dart:async';
import 'dart:io';
import 'package:pruzi_korak/core/constants/app_constants.dart';
import 'package:workmanager/workmanager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

import '../../data/health_data/bg_flush_cache.dart';
import '../../core/utils/app_logger.dart';

const String kBgTaskName = 'flush-today-distance';
const String kLastSyncAttemptKey = 'last_sync_attempt_timestamp';
const String kPendingSyncKey = 'pending_sync_data';

final GetIt getItBg = GetIt.asNewInstance();

Future<void> _bootstrapBgDI() async {
  final prefs = await SharedPreferences.getInstance();
  if (!getItBg.isRegistered<SharedPreferences>()) {
    getItBg.registerSingleton<SharedPreferences>(prefs);
  }

  if (!getItBg.isRegistered<SupabaseClient>()) {
    await Supabase.initialize(
      url: AppConstants.SUPABASE_URL,
      anonKey: AppConstants.SUPABASE_KEY,
    );

    getItBg.registerSingleton<SupabaseClient>(Supabase.instance.client);
  }
}

Future<bool> _waitForDns(String host,
    {int tries = 3, Duration delay = const Duration(seconds: 5)}) async {
  for (var i = 0; i < tries; i++) {
    try {
      final res = await InternetAddress.lookup(host)
          .timeout(const Duration(seconds: 5));
      if (res.isNotEmpty) return true;
    } catch (_) {
    }
    await Future.delayed(delay);
  }
  return false;
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  AppLogger.logInfo("BG Task: callbackDispatcher triggered");

  Workmanager().executeTask((task, inputData) async {
    try {
      await _bootstrapBgDI();

      // Always return success for the task since we're using a local-first approach
      bool taskSuccess = true;

      // Read today's data from cache
      final km = await BgFlushCache.readToday();
      AppLogger.logInfo("BG Task: Read from cache: $km kilometers");

      // Don't proceed if data is null or not positive
      if (km == null || km <= 0.0) {
        AppLogger.logInfo("BG Task: No valid kilometers data found (null or <= 0), exiting with success");
        return Future.value(true);
      }

      // Try to sync data but don't fail the task if sync fails
      bool syncSuccess = false;
      try {
        final supa = Supabase.instance.client;
        final host = Uri.parse(AppConstants.SUPABASE_URL).host;

        final dnsOk = await _waitForDns(host);
        if (!dnsOk) {
          AppLogger.logWarning("BG Task: DNS lookup failed for $host, will retry later");
          // Store last sync attempt timestamp
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt(kLastSyncAttemptKey, DateTime.now().millisecondsSinceEpoch);
          return Future.value(taskSuccess); // Return success even though sync failed
        }

        AppLogger.logInfo("BG Task: Invoking sync-today-distances function with $km kilometers");
        final resp = await supa.functions
            .invoke('sync-today-distances', body: {'kilometers': km})
            .timeout(const Duration(seconds: 20));

        AppLogger.logInfo("BG Task: Function response status: ${resp.status}");

        syncSuccess = resp.status == 200;
        if (syncSuccess) {
          await BgFlushCache.clearToday();
          AppLogger.logInfo("BG Task: Cache cleared after successful sync");
        } else {
          AppLogger.logWarning(
              "BG Task: Failed to sync data, status code: ${resp.status}. Will retry later.");
          // Store last sync attempt timestamp
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt(kLastSyncAttemptKey, DateTime.now().millisecondsSinceEpoch);
        }
      } catch (e) {
        AppLogger.logError("BG Task: Error while attempting to sync", e);
        // Store last sync attempt timestamp
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(kLastSyncAttemptKey, DateTime.now().millisecondsSinceEpoch);
      }

      // Always return success for the WorkManager task
      return Future.value(taskSuccess);
    } catch (e) {
      AppLogger.logError("BG Task: Critical error in background task", e);
      // Return false only for critical errors that affect the task itself
      return Future.value(false);
    }
  });
}
