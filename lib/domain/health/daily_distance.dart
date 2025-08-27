import 'package:equatable/equatable.dart';

class DailyDistance extends Equatable {
  final String date;
  final double totalKilometers;

  const DailyDistance({
    required this.date,
    required this.totalKilometers,
  });

  factory DailyDistance.fromJson(Map<String, dynamic> json) {
    final kilometers = json['total_kilometers'] != null
        ? (json['total_kilometers'] as num).toDouble()
        : 0.0;

    return DailyDistance(
      date: json['date'] as String,
      totalKilometers: kilometers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'total_kilometers': totalKilometers,
    };
  }

  bool isValid() {
    return date.isNotEmpty && totalKilometers > 0.0;
  }

  @override
  List<Object?> get props => [date, totalKilometers];
}
