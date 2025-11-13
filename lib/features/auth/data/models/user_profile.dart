import 'dart:convert';

class UserProfile {
  final String username;
  final String email;
  final String password;
  final String? address;

  const UserProfile({
    required this.username,
    required this.email,
    required this.password,
    this.address,
  });

  UserProfile copyWith({
    String? username,
    String? email,
    String? password,
    String? address,
  }) {
    return UserProfile(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
      'address': address,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      username: map['username']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      password: map['password']?.toString() ?? '',
      address: map['address']?.toString(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(jsonDecode(source) as Map<String, dynamic>);
}


