class UserProfile {
  final String? profilePictureURL;

  UserProfile({this.profilePictureURL});

  factory UserProfile.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserProfile();
    return UserProfile(
      profilePictureURL: json['profilePictureURL'] as String?,
    );
  }
}

class Author {
  final int id;
  final String fullname;
  final UserProfile? userProfile;

  Author({required this.id, required this.fullname, this.userProfile});

  factory Author.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Author(id: 0, fullname: 'Unknown');
    }

    return Author(
      id: json['id'] ?? 0,
      fullname: json['fullname'] ?? 'Unknown',
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
  List<Comment> children = [];
  bool hasChildren = false;

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
    this.children = const [],
    this.hasChildren = false,
  });

  factory Comment.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("Comment JSON data is null");
    }

    return Comment(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      parentId: json['parentId'], // can be null
      postId: json['postId'] ?? 0,
      authorId: json['authorId'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
      author: Author.fromJson(json['Author']),
      voteCounter: json['voteCount'] ?? 0,
      voteType: json['voteType'] ?? "NONE",
      hasChildren: json['hasChildren'] ?? false,
    );
  }
}
