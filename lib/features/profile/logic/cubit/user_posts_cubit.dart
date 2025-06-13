import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/user_posts_states.dart';
import '../../../home/data/models/post_model.dart';
import '../../service/user_posts_service.dart';

class UserPostCubit extends Cubit<UserPostState> {
  final UserPostApiService userPostApiService;
  List<Post> _cachedPosts = [];
  UserPostCubit(this.userPostApiService) : super(UserPostInitial());

  void fetchPostsByUser(int userId, {forceRefresh = false}) async {
    if (_cachedPosts.isNotEmpty && !forceRefresh) {
      emit(UserPostLoaded(_cachedPosts));
      return;
    }
    emit(UserPostLoading());
    try {
      final posts = await userPostApiService.fetchPostsByUser(userId);
      if (!_arePostsEqual(_cachedPosts, posts)) {
        _cachedPosts = posts;
      } else {
        emit(UserPostLoaded(_cachedPosts));
      }
      emit(UserPostLoaded(posts));
    } catch (e) {
      emit(UserPostError(e.toString()));
    }
  }

  Future<void> deletePost(int userId, int postId) async {
    emit(UserPostLoading());
    try {
      await userPostApiService.deletePost(postId);
      final posts = await userPostApiService.fetchPostsByUser(userId);
      emit(UserPostLoaded(posts));
    } catch (e) {
      emit(UserPostError(e.toString()));
    }
  }

  Future<void> editPost(
      int userId, int postId, Map<String, dynamic> updatedData) async {
    emit(UserPostLoading());
    try {
      await userPostApiService.editPost(postId, updatedData);
      final posts = await userPostApiService.fetchPostsByUser(userId);
      emit(UserPostLoaded(posts));
    } catch (e) {
      emit(UserPostError(e.toString()));
    }
  }
  bool _arePostsEqual(List<Post> oldList, List<Post> newList) {
    if (oldList.length != newList.length) return false;
    return true;
  }
}
