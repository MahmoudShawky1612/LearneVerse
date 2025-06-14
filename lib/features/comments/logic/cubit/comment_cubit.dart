import 'package:bloc/bloc.dart';
import 'package:flutterwidgets/features/comments/data/models/comment_model.dart';
import '../../service/comment_service.dart';
import 'comment_states.dart';

class CommentCubit extends Cubit<CommentStates> {
  final CommentService commentService;
  final Map<int, List<Comment>> _cachedComments = {}; // ✅ cache per postId

  CommentCubit(this.commentService) : super(CommentInitial());

  Future<void> createComment(String content, int postId, int? parentId) async {
    emit(CommentLoading());
    try {
      final comment = await commentService.createComment(
          content: content, postId: postId, parentId: parentId);
      // Clear cache for that post to refetch
      _cachedComments.remove(postId);
      // Emit both states to handle UI updates
      emit(CommentCreated(comment));
      // Fetch updated comments to ensure UI is in sync
      await fetchComments(postId, forceRefresh: true);
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> fetchComments(int postId, {bool forceRefresh = false}) async {
    final cached = _cachedComments[postId];
    if (cached != null && !forceRefresh) {
      emit(CommentsFetched(cached));
      return;
    }

    emit(CommentLoading());
    try {
      final comments = await commentService.getComments(postId: postId);
      _cachedComments[postId] = comments;
      emit(CommentsFetched(comments));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  // Clear cache for a specific post
  void clearPostCache(int postId) {
    _cachedComments.remove(postId);
  }
}
