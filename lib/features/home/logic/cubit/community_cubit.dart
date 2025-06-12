import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/community_model.dart';
import '../../service/community_service.dart';
import 'community_states.dart'; // We'll define this next

class CommunityCubit extends Cubit<CommunityStates> {
  final CommunityApiService communityApiService;

  CommunityCubit(this.communityApiService) : super(CommunityLoading());

  Future<void> fetchCommunities() async {
    try {
      emit(CommunityLoading());
      final List<Community> communities =
          await communityApiService.getCommunities();
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
}
