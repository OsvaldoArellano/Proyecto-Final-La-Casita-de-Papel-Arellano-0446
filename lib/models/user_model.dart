class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isAdmin;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      profileImageUrl: map['profileImageUrl'],
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    bool? isAdmin,
    String? profileImageUrl,
  }) {
    return UserModel(
      id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        isAdmin: isAdmin ?? this.isAdmin,
        profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}