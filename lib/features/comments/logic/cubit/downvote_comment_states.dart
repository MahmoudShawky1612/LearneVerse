abstract class DownVoteCommentStates {}

class DownVoteCommentInitial extends DownVoteCommentStates {}

class DownVoteCommentLoading extends DownVoteCommentStates {}

class DownVoteCommentSuccess extends DownVoteCommentStates {}

class DownVoteCommentFailure extends DownVoteCommentStates {
  final String message;
  DownVoteCommentFailure(this.message);
}
