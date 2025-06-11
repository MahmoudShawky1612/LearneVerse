

import 'package:bloc/bloc.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/profile_state.dart';

import '../../services/profile_api_services.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserProfileApiService apiService;

  ProfileCubit(this.apiService) : super(ProfileInitial());

  void loadProfile(int userId) async {
    emit(ProfileLoading());
    try {
      final profile = await apiService.fetchUserProfile(userId);
       emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
