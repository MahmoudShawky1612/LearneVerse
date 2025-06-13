import 'package:bloc/bloc.dart';
import 'package:flutterwidgets/features/comments/data/models/comment_model.dart';
import '../../service/comment_service.dart';
import 'comment_states.dart';

class CommentCubit extends Cubit<CommentStates> {
  final CommentService commentService;
  List<Comment> _cachedComments = [];
  CommentCubit(this.commentService) : super(CommentInitial());

  Future<void> createComment(String content, int postId, int? parentId) async {
    emit(CommentLoading());
    try {
      final comment = await commentService.createComment(
          content: content, postId: postId, parentId: parentId);
      emit(CommentCreated(comment));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> fetchComments(int postId, {forceRefresh = false}) async {
    if (_cachedComments.isNotEmpty && !forceRefresh) {
      emit(CommentsFetched(_cachedComments));
      return;
    }
    emit(CommentLoading());
    try {
      final comments = await commentService.getComments(postId: postId);

      if(!_areCommentsEqual(_cachedComments, comments)) {
        _cachedComments = comments;
        emit(CommentsFetched(comments));
      }else{
        emit(CommentsFetched(_cachedComments));
      }
      emit(CommentsFetched(comments));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }
  bool _areCommentsEqual(List<Comment> oldList, List<Comment> newList) {
    if (oldList.length != newList.length) return false;
    return true;
  }
}
