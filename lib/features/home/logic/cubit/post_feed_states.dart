import '../../data/models/post_model.dart';

abstract class PostFeedState {}

class PostFeedInitial extends PostFeedState {}

class PostFeedLoading extends PostFeedState {}

class PostFeedLoaded extends PostFeedState {
  final List<Post> posts;
  PostFeedLoaded(this.posts);
}

class PostFeedError extends PostFeedState {
  final String message;
  PostFeedError(this.message);
}
