class UserModel {
  final String id;
  final String fullName;
  final String imageUrl;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.imageUrl,
  });

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, imageUrl: $imageUrl)';
  }
}
