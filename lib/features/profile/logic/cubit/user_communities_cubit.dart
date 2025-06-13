import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutterwidgets/features/profile/logic/cubit/user_communities_states.dart';

import '../../../home/data/models/community_model.dart';
import '../../service/user_communities_service.dart';

class UserCommunitiesCubit extends Cubit<UserCommunitiesState> {
  final UserCommunitiesApiService communitiesApiService;
  List<Community> _cachedCommunities = [];
  UserCommunitiesCubit(this.communitiesApiService)
      : super(UserCommunitiesInitial());

  void fetchCommunitiesByUser(int userId, {forceRefresh = false}) async {
    if (_cachedCommunities.isNotEmpty && !forceRefresh) {
      emit(UserCommunitiesLoaded(_cachedCommunities));
      return;
    }
    emit(UserCommunitiesLoading());
    try {
      final communities =
          await communitiesApiService.fetchCommunitiesByUser(userId);
      if (!_areCommunitiesEqual(_cachedCommunities, communities)) {
        _cachedCommunities = communities;
      } else {
        emit(UserCommunitiesLoaded(_cachedCommunities));
      }
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
      final communities =
          await communitiesApiService.fetchCommunitiesByUser(userId);
      emit(UserCommunitiesLoaded(communities));
    } catch (e) {
      emit(UserCommunitiesActionError(e.toString()));
    }
  }
  bool _areCommunitiesEqual(
      List<Community> oldList, List<Community> newList) {
    if (oldList.length != newList.length) return false;
    return true;
  }
}
