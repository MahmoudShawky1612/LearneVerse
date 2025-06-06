import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/home/logic/cubit/post_feed_states.dart';
import 'package:flutterwidgets/features/home/logic/cubit/upvote_states.dart';

import '../../service/feed_post_service.dart';

class UpvoteCubit extends Cubit<UpVoteStates> {
  final FeedPostsApiService feedPostsApiService;
  UpvoteCubit(this.feedPostsApiService) : super(UpVoteInitial());

  void upVote(int id) async {
    emit(UpVoteLoading());
    try {
      final voteData = await feedPostsApiService.upVotePost(id);
      emit(UpVoteSuccess(voteData));
    } catch (e) {
      emit(UpVoteFailure(e.toString()));
    }
  }
}
