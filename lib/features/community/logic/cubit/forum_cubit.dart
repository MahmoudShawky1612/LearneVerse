import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/data/models/post_model.dart';
import '../../services/forum_service.dart';
import 'forum.states.dart';

class ForumCubit extends Cubit<ForumStates> {
  final ForumApiService forumApiService;

  ForumCubit(this.forumApiService) : super(ForumInitial());

  void fetchForumPosts(int forumId) async {
    emit(ForumLoading());
    try {
      final List<Post> posts = await forumApiService.fetchPostsForCommunity(forumId);
      emit(ForumSuccess(posts));
    } catch (e) {
      emit(ForumFailure(e.toString()));
    }
  }
  void createForumPost(int forumId, String title, String content, List<String> attachments) async {
    try {
       await forumApiService.createPost(forumId, title, content, attachments);
      fetchForumPosts(forumId);
    } catch (e) {
      emit(ForumFailure('Failed to create post: $e'));
    }
  }
  Future<void> deletePost(int id, int forumId) async {
    emit(ForumLoading());
    try {
      await forumApiService.deletePost(id);
      fetchForumPosts(forumId);
    } catch (e) {
      emit(ForumFailure(e.toString()));
    }
  }

  Future<void> editPost(int postId, Map<String, dynamic> updatedData, int forumId) async {
    emit(ForumLoading());
    try {
      final updatedPost = await forumApiService.editPost(postId, updatedData);
      fetchForumPosts(forumId);
      emit(EditPostSuccess(updatedPost));
    } catch (e) {
      emit(ForumFailure(e.toString()));
    }
  }
}
