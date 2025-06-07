
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/comments/data/models/comment_model.dart';
import 'package:flutterwidgets/features/comments/services/comment_service.dart';

import 'downvote_comment_states.dart';

class DownvoteCommentCubit extends Cubit<DownVoteCommentStates> {
  final CommentService commentService;
  DownvoteCommentCubit(this.commentService) : super(DownVoteCommentInitial());

  void downVoteComment(Comment comment) async {
    emit(DownVoteCommentLoading());
    try {
      await commentService.downVoteComment(comment);
      emit(DownVoteCommentSuccess());
    } catch (e) {
      emit(DownVoteCommentFailure(e.toString()));
    }
  }
}
