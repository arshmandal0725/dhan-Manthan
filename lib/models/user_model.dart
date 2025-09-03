import 'dart:convert';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? image; // optional (Google profile pic)

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.image,
  });

  // Convert model to Map
  Map<String, dynamic> toMap() {
    return {'uid': uid, 'name': name, 'email': email, 'image': image};
  }

  // Convert Map to model
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      image: map['image'],
    );
  }

  // Convert model to JSON
  String toJson() => json.encode(toMap());

  // Convert JSON to model
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
