class UserModel {
  final String id;
  final String fullName;

  const UserModel({
    required this.id,
    required this.fullName,
  });

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName)';
  }
}
