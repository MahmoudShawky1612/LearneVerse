import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/user_posts_states.dart';
  import '../../services/user_posts_service.dart';

class UserPostCubit extends Cubit<UserPostState> {
  final UserPostApiService userPostApiService;

  UserPostCubit(this.userPostApiService) : super(UserPostInitial());

  void fetchPostsByUser(int userId) async {
    emit(UserPostLoading());
    try {
      final posts = await userPostApiService.fetchPostsByUser(userId);
      emit(UserPostLoaded(posts));
    } catch (e) {
      emit(UserPostError(e.toString()));
    }
  }
}
