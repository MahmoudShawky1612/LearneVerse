import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/post_model.dart';
import 'post_feed_states.dart';
import '../../service/feed_post_service.dart';

class PostFeedCubit extends Cubit<PostFeedState> {
  final FeedPostsApiService apiService;
  List<Post> _cachedPosts = [];
  final Map<int, Post> _postCache = {}; // Cache individual posts by ID

  PostFeedCubit(this.apiService) : super(PostFeedInitial());

  Future<void> fetchFeedPosts({bool forceRefresh = false}) async {
    if (_cachedPosts.isNotEmpty && !forceRefresh) {
      emit(PostFeedLoaded(_cachedPosts));
      return;
    }

    emit(PostFeedLoading());
    try {
      final posts = await apiService.fetchMyFeedPosts();
      _updateCache(posts);
      emit(PostFeedLoaded(_cachedPosts));
    } catch (e) {
      emit(PostFeedError(e.toString()));
    }
  }

  // Update a single post in the cache
  void updatePost(Post updatedPost) {
    final index = _cachedPosts.indexWhere((post) => post.id == updatedPost.id);
    if (index != -1) {
      _cachedPosts[index] = updatedPost;
      _postCache[updatedPost.id] = updatedPost;
      emit(PostFeedLoaded(_cachedPosts));
    }
  }

  // Update the cache with new posts
  void _updateCache(List<Post> newPosts) {
    _cachedPosts = newPosts;
    for (var post in newPosts) {
      _postCache[post.id] = post;
    }
  }

  // Get a single post from cache
  Post? getPostFromCache(int postId) {
    return _postCache[postId];
  }

  // Clear the cache
  void clearCache() {
    _cachedPosts.clear();
    _postCache.clear();
  }
}
