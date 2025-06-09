import 'package:flutterwidgets/features/comments/data/models/comment_model.dart';

abstract class UserCommentsState {}

class UserCommentsInitial extends UserCommentsState {}

class UserCommentsLoading extends UserCommentsState {}

class UserCommentsLoaded extends UserCommentsState {
  final List<Comment> comments;
  UserCommentsLoaded(this.comments);
}

class UserCommentsError extends UserCommentsState {
  final String message;
  UserCommentsError(this.message);
}