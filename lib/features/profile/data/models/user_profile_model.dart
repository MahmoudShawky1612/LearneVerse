class UserProfile {
  final String? bio;
  final String? twitter;
  final String? facebook;
  final String? instagram;
  final String? linkedin;
  final String? youtube;
  final String? profilePictureURL;
  final List<String> tags;

  UserProfile({
    this.bio,
    this.twitter,
    this.facebook,
    this.instagram,
    this.linkedin,
    this.youtube,
    this.profilePictureURL,
    required this.tags,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      bio: json['bio'] as String?,
      twitter: json['twitter'] as String?,
      facebook: json['facebook'] as String?,
      instagram: json['instagram'] as String?,
      linkedin: json['linkedin'] as String?,
      youtube: json['youtube'] as String?,
      profilePictureURL: json['profilePictureURL'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
