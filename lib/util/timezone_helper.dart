import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Helper for configuring the app's timezone.
class TimezoneHelper {
  /// Initializes and sets the local timezone.
  static Future<void> configure() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }
}
