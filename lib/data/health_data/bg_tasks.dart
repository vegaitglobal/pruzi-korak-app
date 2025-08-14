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
    // (opciono) eksplicitno povuci sesiju
   // await Supabase.instance.client.auth.recoverSession();

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

      final supa = Supabase.instance.client;
      final host = Uri.parse(AppConstants.SUPABASE_URL).host;


      final dnsOk = await _waitForDns(host);
      if (!dnsOk) {
        AppLogger.logWarning("BG Task: DNS lookup failed for $host");
        return Future.value(false);
      }

      final km = await BgFlushCache.readToday();
      AppLogger.logInfo("BG Task: Read from cache: $km kilometers");

      if (km == null) {
        AppLogger.logInfo("BG Task: No kilometers data found, exiting");
        return Future.value(true);
      }

      AppLogger.logInfo("BG Task: Invoking sync-today-distances function with $km kilometers");
      final resp = await supa.functions
          .invoke('sync-today-distances', body: {'kilometers': km})
          .timeout(const Duration(seconds: 20));

      AppLogger.logInfo("BG Task: Function response status: ${resp.status}");

      final ok = resp.status == 200;
      if (ok) {
        await BgFlushCache.clearToday();
        AppLogger.logInfo("BG Task: Cache cleared successfully");
      } else {
        AppLogger.logWarning("BG Task: Failed to sync data, status code: ${resp.status}");
      }
      return Future.value(ok);
    } catch (e) {
      AppLogger.logError("BG Task: Error in background task", e);
      return Future.value(false);
    }
  });
}
