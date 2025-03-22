class AppUser {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int roleId;
  final String roleName;
  final String profileStatus;
  final String? photoUrl;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.roleId,
    required this.roleName,
    required this.profileStatus,
    this.photoUrl,
  });
}
