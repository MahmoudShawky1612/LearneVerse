import 'dart:convert';

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
  });

  // Factory constructor to create a Community object from a JSON map
  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      bio: json['bio'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      coverImgURL: json['coverImgURL'],
      logoImgURL: json['logoImgURL'],
      ownerId: json['ownerId'],
      isPublic: json['isPublic'],
      memberCount: json['memberCount'] ?? 0,
    );
  }

  // Method to convert a Community object to a JSON map
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
      'memberCount': memberCount,
    };
  }
}
