import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pruzi_korak/app/app.dart';
import 'package:pruzi_korak/data/notification/local_notification_handler.dart';
import 'package:pruzi_korak/util/timezone_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/di/injector.dart';
import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await TimezoneHelper.configure();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await initSupabase();
  await configureDI();

  // Check if app cold start from notification click
  final notificationAppLaunchDetails =
      await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
  final initialPayload =
      notificationAppLaunchDetails?.notificationResponse?.payload;

  // Initialize notifications
  await getIt<LocalNotificationHandler>().init(initialPayload);

  runApp(
    kDebugMode
        ? DevicePreview(
          enabled: true,
          tools: const [...DevicePreview.defaultTools],
          builder: (context) => const MyApp(),
        )
        : const MyApp(),
  );
}

Future<void> initSupabase() async => Supabase.initialize(
  url: AppConstants.SUPABASE_URL,
  anonKey: AppConstants.SUPABASE_KEY,
);
