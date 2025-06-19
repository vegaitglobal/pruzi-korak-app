import 'package:pruzi_korak/app/di/injector.dart';
import 'package:pruzi_korak/app/navigation/app_routes.dart';
import 'package:pruzi_korak/data/notification/local_notification_service.dart';
import 'package:pruzi_korak/data/notification/notification_type.dart';

import 'navigation/navigation_router.dart';

Future<void> initLocalNotifications() async {
  final plugin = getIt<LocalNotificationService>().plugin;
  final launchDetails = await plugin.getNotificationAppLaunchDetails();

  final payload = launchDetails?.notificationResponse?.payload;

  if (payload != null) {
    _handleNotificationTap(payload);
  }

  await getIt<LocalNotificationService>().init(
    onNotificationTap: _handleNotificationTap,
  );
}

void _handleNotificationTap(String? payload) {
  if (payload == null) return;

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


// TODO: This is example code for showing a notification immediately.
// await getIt<LocalNotificationService>().showNow(
//   title: 'Bravo!',
//   body: 'Uspešno ste završili današnji izazov!',
//   payload: 'instant|3.5',
// );