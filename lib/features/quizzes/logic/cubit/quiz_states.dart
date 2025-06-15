import '../../data/models/quiz_model.dart';

abstract class QuizStates {}

class QuizInitial extends QuizStates {}

class QuizLoading extends QuizStates {}

class QuizLoaded extends QuizStates {
  final List<Quiz> quizzes;
  QuizLoaded(this.quizzes);
}

class QuizError extends QuizStates {
  final String message;
  QuizError(this.message);
} 