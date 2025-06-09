
import '../../../home/data/models/post_model.dart';


abstract class ForumStates {}

class ForumInitial extends ForumStates {}

class ForumLoading extends ForumStates {}

class ForumSuccess extends ForumStates {
  final List<Post> posts;
  ForumSuccess(this.posts);
}

class ForumFailure extends ForumStates {
  final String message;
  ForumFailure(this.message);
}
