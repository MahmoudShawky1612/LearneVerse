class CommunityMember {
  final int id;
  final String fullname;
  final String email;
  final String? profilePictureURL;
  final String username;
  final String role;

  CommunityMember({
    required this.id,
    required this.fullname,
    required this.email,
    this.profilePictureURL,
    required this.role,
    required this.username,
  });

  factory CommunityMember.fromJson(Map<String, dynamic> json) {
    return CommunityMember(
      id: json['id'],
      fullname: json['fullname'],
      email: json['email'],
      profilePictureURL: json['profilePictureURL'] ??'',
      role: json['role'],
      username: json['username'],
    );
  }
}
