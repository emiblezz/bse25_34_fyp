class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int roleId;
  final String roleName;
  final String profileStatus;
  final String? photoUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.roleId,
    required this.roleName,
    required this.profileStatus,
    this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_ID'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      roleId: json['role_ID'],
      roleName: json['role_name'],
      profileStatus: json['profile_status'],
      photoUrl: json['photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_ID': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role_ID': roleId,
      'role_name': roleName,
      'profile_status': profileStatus,
      'photo_url': photoUrl,
    };
  }
}