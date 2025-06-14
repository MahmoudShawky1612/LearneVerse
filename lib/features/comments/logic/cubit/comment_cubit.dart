import 'package:bloc/bloc.dart';
import 'package:flutterwidgets/features/comments/data/models/comment_model.dart';
import '../../service/comment_service.dart';
import 'comment_states.dart';

class CommentCubit extends Cubit<CommentStates> {
  final CommentService commentService;
  final Map<int, List<Comment>> _cachedComments = {}; // ✅ cache per postId
  final Map<int, List<Comment>> _cachedChildren = {}; // Cache for comment children

  CommentCubit(this.commentService) : super(CommentInitial());

  Future<void> createComment(String content, int postId, int? parentId) async {
    emit(CommentLoading());
    try {
      final comment = await commentService.createComment(
          content: content, postId: postId, parentId: parentId);
      
      // If this is a reply, update the parent's children cache
      if (parentId != null) {
        final parentChildren = _cachedChildren[parentId] ?? [];
        _cachedChildren[parentId] = [...parentChildren, comment];
        // Update the parent comment's hasChildren flag
        final allComments = _cachedComments[postId] ?? [];
        final updatedComments = allComments.map((c) {
          if (c.id == parentId) {
            return Comment(
              id: c.id,
              content: c.content,
              parentId: c.parentId,
              postId: c.postId,
              authorId: c.authorId,
              createdAt: c.createdAt,
              updatedAt: c.updatedAt,
              author: c.author,
              voteCounter: c.voteCounter,
              voteType: c.voteType,
              hasChildren: true,
            );
          }
          return c;
        }).toList();
        _cachedComments[postId] = updatedComments;
        emit(CommentCreated(comment));
        emit(CommentsFetched(updatedComments));
      } else {
        // For top-level comments, add to existing comments
        final currentComments = _cachedComments[postId] ?? [];
        _cachedComments[postId] = [comment, ...currentComments];
        emit(CommentCreated(comment));
        emit(CommentsFetched(_cachedComments[postId]!));
      }
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
      // Filter out replies (comments with parentId) from the main list
      final topLevelComments = comments.where((c) => c.parentId == null).toList();
      
      // Check for comments with replies and fetch their children
      for (final comment in topLevelComments) {
        try {
          final children = await commentService.getCommentChildren(comment.id);
          if (children.isNotEmpty) {
            _cachedChildren[comment.id] = children;
            comment.hasChildren = true;
          }
        } catch (e) {
          print('Error fetching children for comment ${comment.id}: $e');
        }
      }
      
      _cachedComments[postId] = topLevelComments;
      emit(CommentsFetched(topLevelComments));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<List<Comment>> fetchCommentChildren(int commentId) async {
    final cached = _cachedChildren[commentId];
    if (cached != null) {
      return cached;
    }

    try {
      final children = await commentService.getCommentChildren(commentId);
      _cachedChildren[commentId] = children;
      return children;
    } catch (e) {
      emit(CommentError(e.toString()));
      return [];
    }
  }

  // Clear cache for a specific post
  void clearPostCache(int postId) {
    _cachedComments.remove(postId);
  }

  // Clear cache for a specific comment's children
  void clearCommentChildrenCache(int commentId) {
    _cachedChildren.remove(commentId);
  }
}
