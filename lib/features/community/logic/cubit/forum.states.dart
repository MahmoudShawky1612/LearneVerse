import '../../../home/data/models/post_model.dart';

abstract class ForumStates {}

class ForumInitial extends ForumStates {}

class ForumLoading extends ForumStates {}

class ForumSuccess extends ForumStates {
  final List<Post> posts;
  ForumSuccess(this.posts);
}

class DeletePostSuccess extends ForumStates {}

class EditPostSuccess extends ForumStates {
  final Post updatedPost;
  EditPostSuccess(this.updatedPost);
}

class ForumFailure extends ForumStates {
  final String message;
  ForumFailure(this.message);
}
