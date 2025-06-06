import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/feed_post_service.dart';
import 'downvote_states.dart';

class DownvoteCubit extends Cubit<DownVoteStates> {
  final FeedPostsApiService feedPostsApiService;
  DownvoteCubit(this.feedPostsApiService) : super(DownVoteInitial());

  void downVote(int id) async {
    emit(DownVoteLoading());
    try {
      final voteData = await feedPostsApiService.downVotePost(id);
      emit(DownVoteSuccess(voteData));
    } catch (e) {
      emit(DownVoteFailure(e.toString()));
    }
  }
}
