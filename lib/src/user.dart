import 'dart:convert';

// getting a list of users from json
List<User> UserFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));
// getting a single user from json
User singleUserFromJson(String str) => User.fromJson(json.decode(str));

// user class
class User {
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.provider,
    required this.confirmed,
    required this.blocked,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String username;
  String email;
  String provider;
  bool confirmed;
  bool blocked;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        provider: json["provider"],
        confirmed: json["confirmed"],
        blocked: json["blocked"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  static Map<String, dynamic> toMap(User model) => <String, dynamic>{
        'id': model.id,
        'username': model.username,
        'email': model.email,
        'provider': model.provider,
        'confirmed': model.confirmed,
        'blocked': model.blocked,
        'createdAt': model.createdAt.toIso8601String(),
        'updatedAt': model.updatedAt.toIso8601String(),
      };

  static String serialize(User model) => json.encode(User.toMap(model));

  // static User deserialize(String json) => User.fromJson(jsonDecode(json));
  static User deserialize(String source) => User.fromJson(json.decode(source));
}
