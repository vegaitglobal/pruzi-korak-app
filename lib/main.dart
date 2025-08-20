import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pruzi_korak/app/app.dart';
import 'package:pruzi_korak/data/notification/local_notification_handler.dart';
import 'package:pruzi_korak/util/timezone_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'app/di/injector.dart';
import 'core/constants/app_constants.dart';
import 'data/health_data/bg_tasks.dart';
import 'data/health_data/helth_native_sync.dart';

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

  await _initWorkmanager();

  // Check if app cold start from notification click
  final notificationAppLaunchDetails =
      await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
  final initialPayload =
      notificationAppLaunchDetails?.notificationResponse?.payload;

  // Initialize notifications
  await getIt<LocalNotificationHandler>().init(initialPayload);

  await HealthNativeEvents.instance.install();

  runApp(
    kDebugMode
        ? DevicePreview(
          enabled: false,
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

Future<void> _initWorkmanager() async {
  await Workmanager().initialize(callbackDispatcher);

  await Workmanager().registerPeriodicTask(
    'flush-task-id',
    kBgTaskName,
    frequency: const Duration(minutes: 30),
    initialDelay: const Duration(minutes: 5),
    backoffPolicy: BackoffPolicy.exponential,
    constraints: Constraints(networkType: NetworkType.connected),
  );

  // Test verzija: One-off task sa kratkim delay-em
  //  Workmanager().registerOneOffTask(
  //   'test-flush-task-id',
  //   kBgTaskName,
  //   initialDelay: const Duration(seconds: 240), // Pokreće se nakon 10 sekundi
  //   backoffPolicy: BackoffPolicy.exponential,
  //   constraints: Constraints(networkType: NetworkType.connected),
  // );
}
