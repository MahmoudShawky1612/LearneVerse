import '../../data/models/post_model.dart';

abstract class EditPostState {}

class EditPostInitial extends EditPostState {}

class EditPostLoading extends EditPostState {}

class EditPostSuccess extends EditPostState {
  final Post updatedPost;
  EditPostSuccess(this.updatedPost);
}

class EditPostFailure extends EditPostState {
  final String error;

  EditPostFailure(this.error);
}
