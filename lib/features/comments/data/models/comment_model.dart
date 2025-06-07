class UserProfile {
  final String? profilePictureURL;

  UserProfile({this.profilePictureURL});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      profilePictureURL: json['profilePictureURL'] as String?,
    );
  }
}

class Author {
  final String username;
  final UserProfile? userProfile;

  Author({required this.username, this.userProfile});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      username: json['username'],
      userProfile: json['UserProfile'] != null
          ? UserProfile.fromJson(json['UserProfile'])
          : null,
    );
  }
}


class Comment {
  final int id;
  final String? content;
  final int? parentId;
  final int postId;
  final int authorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Author author;
  int voteCounter = 0;
  String voteType = "NONE";

  Comment({
    required this.id,
    this.content,
    this.parentId,
    required this.postId,
    required this.authorId,
    required this.createdAt,
    required this.updatedAt,
    required this.author,
     this.voteCounter = 0,
     this.voteType = "NONE",
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      parentId: json['parentId'],
      postId: json['postId'],
      authorId: json['authorId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      author: Author.fromJson(json['Author']),
      voteCounter: json['voteCount'] ?? 0,
      voteType: json['voteType'] ?? "NONE",
    );
  }
}
