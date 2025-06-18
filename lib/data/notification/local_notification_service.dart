import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service for managing local notifications.
class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  static const AndroidNotificationDetails _dailyAndroidDetails =
  AndroidNotificationDetails(
    'daily_channel_id',
    'Daily Notifications',
    channelDescription: 'Dnevne lokalne notifikacije',
    importance: Importance.max,
    priority: Priority.high,
  );

  static const AndroidNotificationDetails _instantAndroidDetails =
  AndroidNotificationDetails(
    'instant_channel_id',
    'Instant Notifications',
    channelDescription: 'Ručne notifikacije odmah',
    importance: Importance.max,
    priority: Priority.high,
  );

  LocalNotificationService(this._plugin);

  /// Initializes the notification service.
  Future<void> init({
    required Function(String? payload) onNotificationTap,
  }) async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final darwinInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final linuxInit = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
    );
    final windowsInit = WindowsInitializationSettings(
      appName: 'Pruži Korak',
      appUserModelId: 'org.pruzikorak.pruzi_korak',
      guid: '00000000-0000-0000-0000-000000000000',
    );

    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
      linux: linuxInit,
      windows: windowsInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        onNotificationTap(response.payload);
      },
    );

    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  /// Schedules a daily notification at the specified [hour] and [minute].
  Future<void> scheduleDailyNotification({
    required int hour,
    required int minute,
    required String title,
    required String body,
    String? payload,
    int notificationId = 0,
  }) async {
    final scheduledDate = _nextInstanceOfTime(hour, minute);

    const notificationDetails = NotificationDetails(
      android: _dailyAndroidDetails,
    );

    await _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exact,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  /// Shows a notification immediately.
  Future<void> showNow({
    required String title,
    required String body,
    String? payload,
  }) async {
    const notificationDetails = NotificationDetails(android: _instantAndroidDetails);

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Cancels all scheduled notifications.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Configures the timezone for notifications.
  static Future<void> configureTimezone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }
}