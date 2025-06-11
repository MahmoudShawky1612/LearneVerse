import 'package:bloc/bloc.dart';
import 'package:flutterwidgets/features/home/service/edit_delete_post_service.dart';

import 'delete_post_states.dart';

class DeletePostCubit extends Cubit<DeletePostState> {
  final EditDeletePostApiService editDeletePostApiService;

  DeletePostCubit(this.editDeletePostApiService) : super(DeletePostInitial());

  Future<void> deletePost(int id) async {
    emit(DeletePostLoading());
    try {
      await editDeletePostApiService.deletePost(id);
      emit(DeletePostSuccess());
    } catch (e) {
      emit(DeletePostFailure(e.toString()));
    }
  }
}
