import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/post_model.dart';
import 'post_feed_states.dart';
 import '../../service/feed_post_service.dart';

class PostFeedCubit extends Cubit<PostFeedState> {
  final FeedPostsApiService apiService;

  List<Post> _cachedPosts = [];

  PostFeedCubit(this.apiService) : super(PostFeedInitial());

  Future<void> fetchFeedPosts({bool forceRefresh = false}) async {
     if (_cachedPosts.isNotEmpty && !forceRefresh) {
      emit(PostFeedLoaded(_cachedPosts));
      return;
    }

    emit(PostFeedLoading());
    try {
      final posts = await apiService.fetchMyFeedPosts();

       if (!_arePostsEqual(_cachedPosts, posts)) {
        _cachedPosts = posts;
        emit(PostFeedLoaded(posts));
      } else {
        emit(PostFeedLoaded(_cachedPosts));
      }
    } catch (e) {
      emit(PostFeedError(e.toString()));
    }
  }

  // Clear the cache if needed
  void clearCache() {
    _cachedPosts.clear();
  }

  // Compare posts using id or content
  bool _arePostsEqual(List<Post> oldPosts, List<Post> newPosts) {
    if (oldPosts.length != newPosts.length) return false;
    for (int i = 0; i < oldPosts.length; i++) {
      if (oldPosts[i].id != newPosts[i].id) return false;
    }
    return true;
  }
}
