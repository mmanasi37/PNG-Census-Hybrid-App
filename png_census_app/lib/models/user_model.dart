import 'dart:convert';

enum UserRole {
  enumerator,
  supervisor;

  String get label => name[0].toUpperCase() + name.substring(1);

  static UserRole fromString(String v) =>
      UserRole.values.firstWhere((e) => e.name == v, orElse: () => UserRole.enumerator);
}

class UserModel {
  final String id;
  final String username;
  final String pinHash;
  final UserRole role;
  final String fullName;
  final String province;
  final String district;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.username,
    required this.pinHash,
    required this.role,
    required this.fullName,
    required this.province,
    required this.district,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'pinHash': pinHash,
        'role': role.name,
        'fullName': fullName,
        'province': province,
        'district': district,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
        id: j['id'] as String,
        username: j['username'] as String,
        pinHash: j['pinHash'] as String,
        role: UserRole.fromString(j['role'] as String),
        fullName: j['fullName'] as String,
        province: j['province'] as String,
        district: j['district'] as String,
        createdAt: DateTime.parse(j['createdAt'] as String),
      );

  static List<UserModel> listFromJson(String raw) {
    if (raw.isEmpty) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJson(List<UserModel> users) =>
      jsonEncode(users.map((u) => u.toJson()).toList());
}
