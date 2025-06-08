import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/join_requests_service.dart';
import 'join_requests_states.dart';


class CommunityRoleCubit extends Cubit<CommunityRoleState> {
  final ApiService apiService;

  CommunityRoleCubit(this.apiService) : super(CommunityRoleInitial());

  Future<void> fetchUserRole(int communityId) async {
    emit(CommunityRoleLoading());
    try {
      final role = await apiService.getUserRoleInCommunity(communityId);
      emit(CommunityRoleLoaded(role: role));
    } catch (e) {
      emit(CommunityRoleError(message: e.toString()));
    }
  }

  Future<void> joinCommunity(int communityId) async {
    emit(CommunityRoleLoading());
    try {
      final isDirectJoin = await apiService.createJoinRequest(communityId);
      // If direct join (public community), fetch updated role
      final role = await apiService.getUserRoleInCommunity(communityId);
      emit(CommunityRoleLoaded(role: role));
    } catch (e) {
      emit(CommunityRoleError(message: e.toString()));
    }
  }
}