import 'package:json_annotation/json_annotation.dart';

// Use this commented way

//part 'user.g.dart';

// @JsonSerializable()
// class User {
//   final String id;
//   final String name;
//   final String email;
//
//   User({required this.id, required this.name, required this.email});
//
//   factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
//   Map<String, dynamic> toJson() => _$UserToJson(this);
// }

// This is for demonstration purposes
class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
}