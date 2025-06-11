class Community {
  final int id;
  final String name;
  final String description;
  final String bio;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String coverImgURL;
  final String logoImgURL;
  final int ownerId;
  final bool isPublic;
  final int memberCount;
  final int onlineMembers;
  final List<Tag> Tags;

  Community({
    required this.id,
    required this.name,
    required this.description,
    required this.bio,
    required this.createdAt,
    required this.updatedAt,
    required this.coverImgURL,
    required this.logoImgURL,
    required this.ownerId,
    required this.isPublic,
    required this.memberCount,
    required this.onlineMembers,
    required this.Tags,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      bio: json['bio'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
      coverImgURL: json['coverImgURL'] ?? '',
      logoImgURL: json['logoImgURL'] ?? '',
      ownerId: json['ownerId'] ?? 0,
      isPublic: json['isPublic'] ?? false,
      memberCount: json['membersCount'] ?? 0,
      onlineMembers: json['onlineMembers'] ?? 0,
      Tags: (json['Tags'] as List<dynamic>?)
          ?.map((tagJson) => Tag.fromJson(tagJson))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'coverImgURL': coverImgURL,
      'logoImgURL': logoImgURL,
      'ownerId': ownerId,
      'isPublic': isPublic,
      'membersCount': memberCount,
      'onlineMembers': onlineMembers,
      'Tags': Tags.map((tag) => tag.toJson()).toList(),
    };
  }
}
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
