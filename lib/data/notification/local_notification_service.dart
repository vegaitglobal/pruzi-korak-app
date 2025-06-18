abstract class LocalNotificationService {
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
