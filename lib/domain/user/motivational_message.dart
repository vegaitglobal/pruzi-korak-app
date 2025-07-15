import 'package:equatable/equatable.dart';

class MotivationalMessage extends Equatable {
  final String id;
  final String message;

  const MotivationalMessage({
    required this.id,
    required this.message,
  });

  factory MotivationalMessage.fromJson(Map<String, dynamic> json) {
    return MotivationalMessage(
      id: json['id'] as String,
      message: json['message'] as String,
    );
  }

  @override
  List<Object?> get props => [id, message];
}
