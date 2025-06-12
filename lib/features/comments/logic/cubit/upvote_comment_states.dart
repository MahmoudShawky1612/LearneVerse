abstract class UpVoteCommentStates {}

class UpVoteCommentInitial extends UpVoteCommentStates {}

class UpVoteCommentLoading extends UpVoteCommentStates {}

class UpVoteCommentSuccess extends UpVoteCommentStates {}

class UpVoteCommentFailure extends UpVoteCommentStates {
  final String message;
  UpVoteCommentFailure(this.message);
}
