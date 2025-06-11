class OwnProfileModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String createdAt;
  final String updatedAt;
  final int v;

  OwnProfileModel({
    required this.name,
    required this.email,
    required this.v,
    required this.id,
    required this.createdAt,
    required this.role,
    required this.updatedAt,
  });

  factory OwnProfileModel.fromMap(Map<String, dynamic> map) {
    return OwnProfileModel(
      name: map["name"] ?? '',
      email: map["email"] ?? '',
      v: map['__v'] ?? map['v'] ?? 0,
      id: map['_id'] ?? map['id'] ?? '',
      createdAt: map['createdAt'] ?? '',
      role: map['role'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
    );
  }
}
