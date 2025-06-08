import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/community/logic/cubit/single_community_states.dart';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';

import '../../../home/data/models/post_model.dart';
import '../../services/forum_service.dart';
import '../../services/single_community_service.dart';
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
}
