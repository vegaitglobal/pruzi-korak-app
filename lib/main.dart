import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pruzi_korak/app/app.dart';
import 'package:pruzi_korak/app/navigation/app_routes.dart';
import 'package:pruzi_korak/data/notification/local_notification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/di/injector.dart';
import 'app/navigation/navigation_router.dart' show navigatorKey, router;
import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await LocalNotificationService.configureTimezone();

  await initSupabase();
  await configureDI();

  await initLocalNotifications();

  await getIt<LocalNotificationService>().scheduleDailyNotification(
    hour: DateTime.now().hour,
    minute: DateTime.now().minute + 1, // za test, 1 minut kasnije
    title: 'Test',
    body: 'Ovo je test notifikacija',
  );

  runApp(const MyApp());
}

Future<void> initSupabase() async => Supabase.initialize(
  url: AppConstants.SUPABASE_URL,
  anonKey: AppConstants.SUPABASE_KEY,
);

Future<void> initLocalNotifications() async {
  await getIt<LocalNotificationService>().init(
    onNotificationTap: (payload) {
      if (payload != null) {
        router.go(AppRoutes.motivationalMessage.path());
      }
    },
  );
}
