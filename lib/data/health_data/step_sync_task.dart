import 'dart:io';
import 'package:workmanager/workmanager.dart';
import 'package:health/health.dart';

const taskName = "backgroundStepSync";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (Platform.isAndroid && task == taskName) {
      final health = Health();

      final types = [HealthDataType.STEPS];
      final now = DateTime.now();
      final campaignStart = DateTime(2024, 6, 13);
      final startOfToday = DateTime(now.year, now.month, now.day);

      final granted = await health.requestAuthorization(types);
      if (!granted) return Future.value(false);

      final todaySteps = await health.getHealthDataFromTypes(
        types: types,
        startTime: startOfToday,
        endTime: now,
      );

      final campaignSteps = await health.getHealthDataFromTypes(
        types: types,
        startTime: campaignStart,
        endTime: now,
      );

      final todayTotal = todaySteps.fold<double>(0, (sum, e) => sum + (e.value as num));
      final campaignTotal = campaignSteps.fold<double>(0, (sum, e) => sum + (e.value as num));

      //TODO: Send data to backend

      return Future.value(true);
    }

    return Future.value(false);
  });
}