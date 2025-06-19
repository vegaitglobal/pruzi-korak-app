import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class LocalNotificationService {
  FlutterLocalNotificationsPlugin get plugin;

  Future<void> init({required Function(String? payload) onNotificationTap});

  Future<void> scheduleDailyNotification({
    required int hour,
    required int minute,
    required String title,
    required String body,
    String? payload,
    int notificationId,
  });

  Future<void> showNow({
    required String title,
    required String body,
    String? payload,
  });

  Future<void> cancelAll();
}
