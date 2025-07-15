enum NotificationType {
  daily,
  instant;

  static NotificationType? fromString(String? value) {
    switch (value) {
      case 'daily':
        return NotificationType.daily;
      case 'instant':
        return NotificationType.instant;
      default:
        return null;
    }
  }

  @override
  String toString() {
    return switch (this) {
      NotificationType.daily => 'daily',
      NotificationType.instant => 'instant',
    };
  }
}