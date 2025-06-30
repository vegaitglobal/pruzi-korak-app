import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// A service to handle requesting and checking various app permissions
abstract class PermissionsService {
  /// Request notification permissions
  /// Returns true if permissions are granted
  Future<bool> requestNotificationPermissions();

  /// Check if notification permissions are granted
  Future<bool> checkNotificationPermissions();

  /// Request health data permissions
  /// Returns true if permissions are granted
  Future<bool> requestHealthPermissions();

  /// Check if health data permissions are granted
  Future<bool> checkHealthPermissions();

  /// Request all permissions needed for the app
  /// Returns a map of permission types to boolean values indicating if they are granted
  Future<Map<String, bool>> requestAllPermissions();
}
