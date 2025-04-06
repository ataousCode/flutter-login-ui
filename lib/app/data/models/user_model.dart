// File: app/data/models/user_model.dart
class UserModel {
  final String id;
  final String username;
  final String email;
  String? fullName;
  String? bio;
  String? phone;
  String? website;
  String? location;
  String? photoUrl;
  Map<String, dynamic>? preferences;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.bio,
    this.phone,
    this.website,
    this.location,
    this.photoUrl,
    this.preferences,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      fullName: json['full_name'],
      bio: json['bio'],
      phone: json['phone'],
      website: json['website'],
      location: json['location'],
      photoUrl: json['photo_url'],
      preferences: json['preferences'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'full_name': fullName,
      'bio': bio,
      'phone': phone,
      'website': website,
      'location': location,
      'photo_url': photoUrl,
      'preferences': preferences,
    };
  }
}