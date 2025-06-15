import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/quiz_service.dart';
import 'quiz_states.dart';

class QuizCubit extends Cubit<QuizStates> {
  final QuizService quizService;

  QuizCubit(this.quizService) : super(QuizInitial());

  void fetchCommunityQuizzes(int communityId) async {
    emit(QuizLoading());
    try {
      final quizzes = await quizService.fetchCommunityQuizzes(communityId);
      emit(QuizLoaded(quizzes));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }
} 