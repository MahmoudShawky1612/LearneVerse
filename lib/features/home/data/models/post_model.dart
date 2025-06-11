class Post {
  final int id;
  final String title;
  final String? content;
  final List<String> attachments;
  final int forumId;
  final DateTime createdAt;
  final DateTime updatedAt;
  int voteCounter;
  final int commentCount;
  final Author author;
  String voteType;

  Post({
    required this.id,
    required this.title,
    this.content,
    required this.attachments,
    required this.forumId,
    required this.createdAt,
    required this.updatedAt,
    this.voteCounter = 0,
    this.commentCount = 0,
    required this.author,
    this.voteType = 'NONE',
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'],
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      forumId: json['forumId'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
      voteCounter: json['voteCounter'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      author: json['author'] != null
          ? Author.fromJson(json['author'])
          : Author(
        id: 0,
        username: 'unknown',
        fullname: 'Guest',
        profilePictureURL: null,
      ),
      voteType: json['voteType'] ?? 'NONE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'attachments': attachments,
      'forumId': forumId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'voteCounter': voteCounter,
      'commentCount': commentCount,
      'author': author.toJson(),
      'voteType': voteType,
    };
  }
}
class Author {
  final int id;
  final String username;
  final String fullname;
  final String? profilePictureURL;

  Author({
    required this.id,
    required this.username,
    required this.fullname,
    this.profilePictureURL,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] ?? 0,
      username: json['username'] ?? 'unknown',
      fullname: json['fullname'] ?? 'Guest',
      profilePictureURL: json['profilePictureURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullname': fullname,
      'profilePictureURL': profilePictureURL,
    };
  }
}
