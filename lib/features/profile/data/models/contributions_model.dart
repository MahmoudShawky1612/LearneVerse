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
      id: json['id'],
      userId: json['userId'],
      count: json['count'],
      dateOnly: DateTime.parse(json['dateOnly']),
    );
  }
}