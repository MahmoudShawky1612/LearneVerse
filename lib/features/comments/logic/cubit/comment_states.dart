import '../../data/models/comment_model.dart';

abstract class CommentStates {}

class CommentInitial extends CommentStates {}

class CommentLoading extends CommentStates {}

class CommentCreated extends CommentStates {
  final Comment comment;
  CommentCreated(this.comment);
}

class CommentsFetched extends CommentStates {
  final List<Comment> comments;
  CommentsFetched(this.comments);
}
class CommentError extends CommentStates {
  final String message;
  CommentError(this.message);
}
