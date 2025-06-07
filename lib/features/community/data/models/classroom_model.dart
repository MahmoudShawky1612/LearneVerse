class Classroom {
  final int id;
  final String name;
  final String? description;
  final String? coverImg;
  final int communityId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? progress;

  Classroom({
    required this.id,
    required this.name,
    this.description,
    this.coverImg,
    required this.communityId,
    required this.createdAt,
    required this.updatedAt,
    required this.progress,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      coverImg: json['coverImg'],
      communityId: json['communityId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      progress: json['progress']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'coverImg': coverImg,
      'communityId': communityId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'progress': progress,
    };
  }
}
