import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/profile_state.dart';

import '../../../../utils/jwt_helper.dart';
import '../../services/profile_api_services.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserProfileApiService apiService;
  final String token;

  ProfileCubit(this.apiService, this.token) : super(ProfileInitial());

  void loadProfile() async {
    emit(ProfileLoading());
    try {
      final userId = getUserIdFromToken(token);
      final profile = await apiService.fetchUserProfile(userId, token);
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
