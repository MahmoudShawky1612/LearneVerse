import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/home/data/models/post_model.dart';
import '../../service/feed_post_service.dart';
import 'downvote_states.dart';

class DownvoteCubit extends Cubit<DownVoteStates> {
  final FeedPostsApiService feedPostsApiService;
  DownvoteCubit(this.feedPostsApiService) : super(DownVoteInitial());

  void downVote(Post post) async {
    emit(DownVoteLoading());
    try {
      await feedPostsApiService.downVotePost(post);
      emit(DownVoteSuccess());
    } catch (e) {
      emit(DownVoteFailure(e.toString()));
    }
  }
}
