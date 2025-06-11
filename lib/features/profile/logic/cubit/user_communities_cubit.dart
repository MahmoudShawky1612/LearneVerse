import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:flutterwidgets/features/profile/logic/cubit/user_communities_states.dart';

import '../../services/user_communities_service.dart';

class UserCommunitiesCubit extends Cubit<UserCommunitiesState> {
  final UserCommunitiesApiService communitiesApiService;

  UserCommunitiesCubit(this.communitiesApiService) : super(UserCommunitiesInitial());

  void fetchCommunitiesByUser(int userId) async {
    emit(UserCommunitiesLoading());
    try {
      final communities = await communitiesApiService.fetchCommunitiesByUser(userId);
      emit(UserCommunitiesLoaded(communities));
    } catch (e) {
      emit(UserCommunitiesError(e.toString()));
    }
  }

  Future<void> leaveCommunity(int userId, int communityId) async {
    emit(UserCommunitiesLoading());
    try {
      final message = await communitiesApiService.leaveCommunity(communityId);
      emit(UserCommunitiesActionSuccess(message));
      final communities = await communitiesApiService.fetchCommunitiesByUser(userId);
      emit(UserCommunitiesLoaded(communities));
    } catch (e) {
      emit(UserCommunitiesActionError(e.toString()));
      emit(UserCommunitiesError(e.toString()));
    }
  }
}