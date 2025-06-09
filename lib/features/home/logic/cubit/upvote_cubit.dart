import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/home/logic/cubit/upvote_states.dart';

import '../../data/models/post_model.dart';
import '../../service/feed_post_service.dart';

class UpvoteCubit extends Cubit<UpVoteStates> {
  final FeedPostsApiService feedPostsApiService;
  UpvoteCubit(this.feedPostsApiService) : super(UpVoteInitial());

  void upVote(Post post) async {
    emit(UpVoteLoading());
    try {
       await feedPostsApiService.upVotePost(post);
      emit(UpVoteSuccess());
    } catch (e) {
      emit(UpVoteFailure(e.toString()));
    }
  }
}
