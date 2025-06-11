import 'package:bloc/bloc.dart';
import 'package:flutterwidgets/features/home/service/edit_delete_post_service.dart';

import 'edit_post_states.dart';

class EditPostCubit extends Cubit<EditPostState> {
  final EditDeletePostApiService editDeletePostApiService;

  EditPostCubit(this.editDeletePostApiService) : super(EditPostInitial());

  Future<void> editPost(int postId, Map<String, dynamic> updatedData) async {
    emit(EditPostLoading());
    try {
      final updatedPost = await editDeletePostApiService.editPost(postId, updatedData);
      emit(EditPostSuccess(updatedPost));
    } catch (e) {
      emit(EditPostFailure(e.toString()));
    }
  }
}
