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
      profilePictureURL: json['profilePictureURL']?? 'https://static8.depositphotos.com/1009634/988/v/450/depositphotos_9883921-stock-illustration-no-user-profile-picture.jpg',
      role: json['role'],
      username: json['username'],
    );
  }
}
