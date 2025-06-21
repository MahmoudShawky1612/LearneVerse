import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/quiz_model.dart';
import '../../service/quiz_service.dart';
import 'quiz_states.dart';

class QuizCubit extends Cubit<QuizStates> {
  final QuizService _quizService;

  QuizCubit(this._quizService) : super(QuizInitial());

  Future<void> fetchCommunityQuizzes(int communityId) async {
    emit(QuizLoading());
    try {
      final quizzes = await _quizService.getCommunityQuizzes(communityId);
      emit(QuizLoaded(quizzes));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }

  Future<Quiz> getQuizById(int quizId) async {
    try {
      final quiz = await _quizService.getQuizById(quizId);
      return quiz;
    } catch (e) {
      throw Exception('Failed to load quiz: $e');
    }
  }

  Future<void> submitQuiz(int quizId, DateTime startDate, DateTime endDate, int score) async {
    try {
      await _quizService.submitQuiz(quizId, startDate, endDate, score);
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to submit quiz: $e');
    }
  }
}