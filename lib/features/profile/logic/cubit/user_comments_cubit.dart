import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/comments/data/models/comment_model.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/user_comments_states.dart';

import '../../service/user_comments.service.dart';

class UserCommentsCubit extends Cubit<UserCommentsState> {
  final UserCommentsApiService commentsApiService;
   UserCommentsCubit(this.commentsApiService) : super(UserCommentsInitial());

  void fetchCommentsByUser(int userId, {forceRefresh = false}) async {

    emit(UserCommentsLoading());
    try {
      final comments = await commentsApiService.fetchCommentsByUser(userId);

        emit(UserCommentsLoaded(comments));
    } catch (e) {
      emit(UserCommentsError(e.toString()));
    }
  }

  Future<void> deleteComment(int userId, int commentId) async {
    emit(UserCommentsLoading());
    try {
      await commentsApiService.deleteComment(commentId);
       final comments = await commentsApiService.fetchCommentsByUser(userId);
      emit(UserCommentsLoaded(comments));
    } catch (e) {
      emit(UserCommentsError(e.toString()));
    }
  }

  Future<void> updateComment(
      int userId, int commentId, String newContent) async {
    emit(UserCommentsLoading());
    try {
      await commentsApiService.updateComment(commentId, newContent);
       final comments = await commentsApiService.fetchCommentsByUser(userId);
      emit(UserCommentsLoaded(comments));
    } catch (e) {
      emit(UserCommentsError(e.toString()));
    }
  }

}
