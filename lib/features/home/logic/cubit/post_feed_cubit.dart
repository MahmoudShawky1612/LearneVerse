import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/home/logic/cubit/post_feed_states.dart';

import '../../service/feed_post_service.dart';

class PostFeedCubit extends Cubit<PostFeedState> {
  final FeedPostsApiService feedPostsApiService;
  PostFeedCubit(this.feedPostsApiService) : super(PostFeedInitial());

  void fetchFeedPosts() async {
    emit(PostFeedLoading());
    try {
      final posts = await feedPostsApiService.fetchMyFeedPosts();
      emit(PostFeedLoaded(posts));
    } catch (e) {
      emit(PostFeedError(e.toString()));
    }
  }
}
