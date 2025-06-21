import 'question_model.dart';

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
  final List<QuizQuestion> quizQuestions;
  final int questionCount;
  final bool isAttempted;

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
    required this.quizQuestions,
    required this.questionCount,
    required this.isAttempted,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    List<QuizQuestion> questions = [];
    if (json['QuizQuestions'] != null) {
      questions = (json['QuizQuestions'] as List)
          .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
          .toList();
    }

    final isAttempted = json['isAttempted'] ?? false;
    print('Quiz ${json['id']}: isAttempted from API = $isAttempted');

    return Quiz(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      duration: json['duration'] ?? 0,
      startDate: json['startDate'] != null 
          ? DateTime.parse(json['startDate']) 
          : DateTime.now(),
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate']) 
          : DateTime.now(),
      grade: json['grade'] ?? '',
      classroomId: json['classroomId'] ?? 0,
      active: json['active'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
      quizQuestions: questions,
      questionCount: json['questionCount'] ?? 0,
      isAttempted: isAttempted,
    );
  }
} 