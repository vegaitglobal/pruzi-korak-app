import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'first_name')
  final String fistName;

  @JsonKey(name: 'last_name')
  final String lastName;

  @JsonKey(name: 'team_name')
  final String teamName;

  const UserModel({
    required this.fistName,
    required this.lastName,
    required this.teamName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
