import 'package:equatable/equatable.dart';

class StepsModel extends Equatable {
  final String steps;
  final String totalSteps;

  const StepsModel({required this.steps, required this.totalSteps});

  @override
  List<Object> get props => [steps, totalSteps];
}
