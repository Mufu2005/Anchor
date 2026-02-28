class User {
  final String id;
  final String email;
  final String name;
  final String nickname;
  final String password;
  final String encryption_key;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.nickname,
    required this.password,
    required this.encryption_key,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      nickname: json['nickname'],
      password: json['password'],
      encryption_key: json['encryption_key'],
    );
  }
}