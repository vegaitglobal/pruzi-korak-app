import 'package:pruzi_korak/app/app_config.dart';
import 'package:pruzi_korak/app/navigation/app_routes.dart';
import 'package:pruzi_korak/app/navigation/navigation_router.dart';
import 'package:pruzi_korak/data/notification/local_notification_service.dart';
import 'package:pruzi_korak/domain/auth/AuthRepository.dart';

import 'notification_type.dart';

class LocalNotificationHandler {
  final LocalNotificationService _notificationService;
  final AuthRepository _authRepository;

  LocalNotificationHandler(this._notificationService, this._authRepository);

  Future<void> init() async {
    await _notificationService.init(onNotificationTap: _handleNotificationTap);
  }

  Future<void> scheduleMotivationalNotification({
    required String title,
    required String body,
  }) async {
    await _notificationService.scheduleDailyNotification(
      hour: AppConfig.motivationNotificationHour,
      minute: AppConfig.motivationNotificationMinute,
      title: title,
      body: body,
      payload: NotificationType.daily.toString(),
    );
  }

  /// Shows a notification immediately
  Future<void> showNow({
    required String title,
    required String body,
    String? km,
  }) async {
    await _notificationService.showNow(
      title: title,
      body: body,
      payload: "${NotificationType.instant.toString()}|$km",
    );
  }

  void _handleNotificationTap(String? payload) async {
    if (payload == null) return;

    // Add a small delay to ensure the app is fully initialized
    await Future.delayed(const Duration(milliseconds: 300));

    final isLoggedIn = await _authRepository.isLoggedIn();
    if (!isLoggedIn) {
      router.go(AppRoutes.login.path());
      return;
    }

    final parts = payload.split('|');
    final type = NotificationType.fromString(parts.first);
    final param = parts.length > 1 ? parts[1] : null;

    switch (type) {
      case NotificationType.daily:
        router.go(AppRoutes.motivationalMessage.path());
        break;
      case NotificationType.instant:
        final distance = param ?? '0.0';
        router.pushNamed(
          AppRoutes.congratsMessage.name,
          pathParameters: {'distance': distance},
        );
        break;
      default:
        router.go(AppRoutes.motivationalMessage.path());
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAll();
  }
}
 // Example for now
// getIt<LocalNotificationHandler>()
//     .showNow(
// title: localizations.motivation_notification_title,
// body: localizations.motivation_notification_body,
// km: '11',
// );