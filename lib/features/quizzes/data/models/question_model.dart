class Question {
  final int id;
  final int classroomId;
  final String questionHeader;
  final List<String> options;
  final List<String> answer;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  Question({
    required this.id,
    required this.classroomId,
    required this.questionHeader,
    required this.options,
    required this.answer,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      classroomId: json['classroomId'],
      questionHeader: json['questionHeader'],
      options: List<String>.from(json['options']),
      answer: List<String>.from(json['answer']),
      type: json['type'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class QuizQuestion {
  final int id;
  final int quizId;
  final int questionId;
  final int points;
  final Question question;

  QuizQuestion({
    required this.id,
    required this.quizId,
    required this.questionId,
    required this.points,
    required this.question,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'],
      quizId: json['quizId'],
      questionId: json['questionId'],
      points: json['points'],
      question: Question.fromJson(json['Question']),
    );
  }
} 