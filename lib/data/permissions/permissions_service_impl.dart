import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pruzi_korak/data/permissions/permissions_service.dart';

class PermissionsServiceImpl implements PermissionsService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  PermissionsServiceImpl(this._notificationsPlugin);

  @override
  Future<bool> requestNotificationPermissions() async {
    // Use permission_handler for unified permission handling across platforms
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  @override
  Future<bool> checkNotificationPermissions() async {
    // Check actual notification permission status
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  @override
  Future<bool> requestHealthPermissions() async {
    // Request both activity recognition (steps) and body sensors permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.activityRecognition,
      Permission.sensors,
    ].request();

    // Return true if all permissions are granted
    return statuses.values.every((status) => status.isGranted);
  }

  @override
  Future<bool> checkHealthPermissions() async {
    // Check both activity recognition and body sensors permissions
    bool activityGranted = await Permission.activityRecognition.isGranted;
    bool sensorsGranted = await Permission.sensors.isGranted;

    // Return true if all permissions are granted
    return activityGranted && sensorsGranted;
  }

  @override
  Future<Map<String, bool>> requestAllPermissions() async {
    // Request all permissions one by one
    final notificationsGranted = await requestNotificationPermissions();
    final healthGranted = await requestHealthPermissions();

    return {
      'notifications': notificationsGranted,
      'health': healthGranted,
      // Add more permissions here in the future as needed
    };
  }
}
