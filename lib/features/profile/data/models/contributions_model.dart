class UserContribution {
  final int id;
  final int userId;
  final int count;
  final DateTime dateOnly;

  UserContribution({
    required this.id,
    required this.userId,
    required this.count,
    required this.dateOnly,
  });

  factory UserContribution.fromJson(Map<String, dynamic> json) {
    return UserContribution(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      count: json['count'] ?? 0,
      dateOnly: json['dateOnly'] != null
          ? DateTime.tryParse(json['dateOnly']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
