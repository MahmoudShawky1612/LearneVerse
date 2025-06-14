class Reminder {
  final Community community;

  Reminder({required this.community});

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      community: Community.fromJson(json['Community']),
    );
  }
}

class Community {
  final String name;
  final int id;
  final List<Classroom> classrooms;

  Community({
    required this.name,
    required this.id,
    required this.classrooms,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      name: json['name'],
      id: json['id'],
      classrooms: (json['Classrooms'] as List?)
              ?.map((c) => Classroom.fromJson(c))
              .toList() ??
          [],
    );
  }
}

class Classroom {
  final List<Quiz> quizzes;

  Classroom({required this.quizzes});

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      quizzes: (json['Quiz'] as List?)
              ?.map((q) => Quiz.fromJson(q))
              .toList() ??
          [],
    );
  }
}

class Quiz {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  Quiz({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      name: json['name'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
} 