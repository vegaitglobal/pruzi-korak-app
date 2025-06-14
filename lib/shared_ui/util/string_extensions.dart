extension NonEmptyOrNullExtension on String? {
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;
}

extension CapitalizeFirst on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
