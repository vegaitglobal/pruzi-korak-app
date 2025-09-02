// bg_flush_cache.dart
import 'package:shared_preferences/shared_preferences.dart';

/*
  Utility class to cache today's distance data locally.
  This is used to ensure that if the app is terminated before
  a successful sync, we don't lose the data for today.
  'bg_pending_today_km'' save steps in MainActivity.kt, so we can read data in bg
 */
class BgFlushCache {
  static const _kTodayKey = 'bg_pending_today_km';

  static Future<void> saveToday(double km) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kTodayKey, km);
  }

  static Future<double?> readToday() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_kTodayKey);
  }

  /// Clear today's cached data after successful sync
  static Future<void> clearToday() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTodayKey);
  }
}
