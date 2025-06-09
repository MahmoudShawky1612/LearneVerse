import '../../../home/data/models/post_model.dart';

abstract class UserPostState {}

class UserPostInitial extends UserPostState {}

class UserPostLoading extends UserPostState {}

class UserPostLoaded extends UserPostState {
  final List<Post> posts;
  UserPostLoaded(this.posts);
}

class UserPostError extends UserPostState {
  final String message;
  UserPostError(this.message);
}
