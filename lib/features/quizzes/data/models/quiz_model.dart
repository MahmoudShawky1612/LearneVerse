class Quiz {
  final int id;
  final String name;
  final int duration;
  final DateTime startDate;
  final DateTime endDate;
  final String grade;
  final int classroomId;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  Quiz({
    required this.id,
    required this.name,
    required this.duration,
    required this.startDate,
    required this.endDate,
    required this.grade,
    required this.classroomId,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      duration: json['duration'] ?? 0,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      grade: json['grade'] ?? '',
      classroomId: json['classroomId'] ?? 0,
      active: json['active'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
} 