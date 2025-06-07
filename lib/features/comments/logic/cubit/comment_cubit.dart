import 'package:bloc/bloc.dart';
import '../../services/comment_service.dart';
import 'comment_states.dart';


class CommentCubit extends Cubit<CommentStates> {
  final CommentService commentService;

  CommentCubit(this.commentService) : super(CommentInitial());

  Future<void> createComment(String content, int postId) async {
    emit(CommentLoading());
    try {
      final comment = await commentService.createComment(content: content, postId: postId);
      emit(CommentCreated(comment));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> fetchComments(int postId) async {
    emit(CommentLoading());
    try {
      final comments = await commentService.getComments(postId: postId);
      emit(CommentsFetched(comments));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }
}
