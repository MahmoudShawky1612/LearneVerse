class Post {
  final int id;
  final String title;
  final String? content;
  final List<String> attachments;
  final int forumId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int voteCounter;
  final int commentCount;
  final Author author;

  Post({
    required this.id,
    required this.title,
    this.content,
    required this.attachments,
    required this.forumId,
    required this.createdAt,
    required this.updatedAt,
    required this.voteCounter,
    required this.commentCount,
    required this.author,
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
      voteCounter: json['voteCounter'],
      commentCount: json['commentCount'],
      author: Author.fromJson(json['author']),
    );
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
}
