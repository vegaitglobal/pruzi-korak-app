// bg_flush_cache.dart
import 'package:shared_preferences/shared_preferences.dart';

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

  static Future<void> clearToday() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTodayKey);
  }
}
