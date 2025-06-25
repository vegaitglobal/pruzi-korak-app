import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  await initSupabase();
  await configureDI();

  // Initialize notifications
  await getIt<LocalNotificationHandler>().init();

  runApp(const MyApp());
}

Future<void> initSupabase() async => Supabase.initialize(
  url: AppConstants.SUPABASE_URL,
  anonKey: AppConstants.SUPABASE_KEY,
);
