class UserModel {
  final String uid;
  final bool isAnonymous;
  final String displayName;
  final String avatar;
  final String slug;

  const UserModel({
    required this.uid,
    required this.displayName,
    required this.avatar,
    required this.slug,
    this.isAnonymous = false,
  });
}
