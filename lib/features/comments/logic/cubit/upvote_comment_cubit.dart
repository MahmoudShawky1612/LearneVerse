import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/comments/data/models/comment_model.dart';
import 'package:flutterwidgets/features/comments/logic/cubit/upvote_comment_states.dart';
import 'package:flutterwidgets/features/comments/service/comment_service.dart';

class UpvoteCommentCubit extends Cubit<UpVoteCommentStates> {
  final CommentService commentService;
  UpvoteCommentCubit(this.commentService) : super(UpVoteCommentInitial());

  void upVoteComment(Comment comment) async {
    emit(UpVoteCommentLoading());
    try {
      await commentService.upVoteComment(comment);
      emit(UpVoteCommentSuccess());
    } catch (e) {
      emit(UpVoteCommentFailure(e.toString()));
    }
  }
}
