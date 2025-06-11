import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/join_requests_service.dart';
import '../../data/models/creat_request_model.dart';
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

class JoinRequestsCubit extends Cubit<JoinRequestsState> {
  final ApiService apiService;

  JoinRequestsCubit(this.apiService) : super(JoinRequestsInitial());

  Future<void> fetchJoinRequests(int communityId) async {
    emit(JoinRequestsLoading());
    try {
      final requests = await apiService.fetchJoinRequests(communityId);
      emit(JoinRequestsLoaded(requests: requests));
    } catch (e) {
      emit(JoinRequestsError(message: e.toString()));
    }
  }
}