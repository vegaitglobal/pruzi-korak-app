import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'local_notification_service.dart';

class LocalNotificationServiceImpl implements LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  LocalNotificationServiceImpl(this._plugin);

  @override
  FlutterLocalNotificationsPlugin get plugin => _plugin;

  @override
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
  }

  @override
  Future<void> scheduleDailyNotification({
    required int hour,
    required int minute,
    required String title,
    required String body,
    String? payload,
    int notificationId = 0,
  }) async {
    final scheduledDate = _nextInstanceOfTime(hour, minute);

    await _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      scheduledDate,
      _buildDailyNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exact,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  @override
  Future<void> showNow({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      _buildInstantNotificationDetails(),
      payload: payload,
    );
  }

  @override
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// Returns the next TZDateTime instance of the given [hour] and [minute].
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Builds details for scheduled daily notifications.
  NotificationDetails _buildDailyNotificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      'daily_channel_id',
      'Daily Notifications',
      channelDescription: 'Dnevne lokalne notifikacije',
      importance: Importance.max,
      priority: Priority.high,
    );
    return const NotificationDetails(android: androidDetails);
  }

  /// Builds details for instant notifications.
  NotificationDetails _buildInstantNotificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      'instant_channel_id',
      'Instant Notifications',
      channelDescription: 'Ručne notifikacije odmah',
      importance: Importance.max,
      priority: Priority.high,
    );
    return const NotificationDetails(android: androidDetails);
  }
}