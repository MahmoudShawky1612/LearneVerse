class Tag {
  final int id;
  final String name;

  Tag({
    required this.id,
    required this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
class User {
  final String fullname;
  final String username;

  User({
    required this.fullname,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullname: json['fullname'] ?? "Guest",
      username: json['username'] ?? 'unknown',
    );
  }
}
class UserProfile {
  final String? bio;
  final String? twitter;
  final String? facebook;
  final String? instagram;
  final String? linkedin;
  final String? youtube;
  final String profilePictureURL;
  final List<Tag> tags;
  final User user;

  UserProfile({
    this.bio,
    this.twitter,
    this.facebook,
    this.instagram,
    this.linkedin,
    this.youtube,
    required this.profilePictureURL,
    required this.tags,
    required this.user,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      bio: json['bio'],
      twitter: json['twitter'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      linkedin: json['linkedin'],
      youtube: json['youtube'],
      profilePictureURL: json['profilePictureURL'] ?? '',
      tags: (json['Tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e))
          .toList() ??
          [],
      user: User.fromJson(json['User']),
    );
  }
}
