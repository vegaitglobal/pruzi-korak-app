import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pruzi_korak/app/app.dart';
import 'package:pruzi_korak/data/health_data/step_sync_task.dart';
import 'package:workmanager/workmanager.dart';

import 'app/di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  await Workmanager().registerPeriodicTask(
    "pruziKorakBackgroundSteps",
    taskName,
    frequency: const Duration(minutes: 30),
    constraints: Constraints(
      networkType: NetworkType.not_required,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await configureDI();

  runApp(const MyApp());
}
