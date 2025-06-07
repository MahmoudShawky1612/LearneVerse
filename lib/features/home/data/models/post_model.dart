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
      id: json['id'],
      title: json['title'],
      content: json['content'],
      attachments: List<String>.from(json['attachments']),
      forumId: json['forumId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      voteCounter: json['voteCounter'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      author: Author.fromJson(json['author']),
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
  final String avatarUrl;

  Author({
    required this.id,
    required this.username,
    required this.fullname,
    required this.avatarUrl,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      username: json['username'],
      fullname: json['fullname'],
      avatarUrl: json['avatarUrl'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullname': fullname,
      'avatarUrl': avatarUrl,
    };
  }
}
