import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/community_model.dart';
import '../../service/community_service.dart';
import 'community_states.dart'; // We'll define this next

class CommunityCubit extends Cubit<CommunityStates> {
  final CommunityApiService communityApiService;
  List<Community> _cachedCommunities = [];
  CommunityCubit(this.communityApiService) : super(CommunityLoading());

  Future<void> fetchCommunities({bool forceRefresh = false}) async {
    if(!forceRefresh && _cachedCommunities.isNotEmpty) {
      emit(CommunitySuccess(_cachedCommunities));
      return;
    }
    emit(CommunityLoading());

    try {
      final List<Community> communities =
      await communityApiService.getCommunities();
      if(!_areCommunitiesEqual(_cachedCommunities,  communities)){
        _cachedCommunities = communities;
      } else {
        emit(CommunitySuccess(_cachedCommunities));
        return;
      }
      emit(CommunitySuccess(communities));
    } catch (error) {
      emit(CommunityFailure('Failed to load communities: $error'));
    }
  }

  Future<int> getCommunityMembersCount(int communityId) async {
    try {
      final int memberCount =
          await communityApiService.communityMembersCount(communityId);
      return memberCount;
    } catch (error) {
      throw Exception('Failed to load member count: $error');
    }
  }
  void clearCache() {
    _cachedCommunities.clear();
  }
  bool _areCommunitiesEqual(List<Community> oldCommunities, List<Community> newCommunities) {
    if (oldCommunities.length != newCommunities.length) return false;
    for (int i = 0; i < oldCommunities.length; i++) {
      if (oldCommunities[i].id != newCommunities[i].id) return false;
    }
    return true;
  }
}
