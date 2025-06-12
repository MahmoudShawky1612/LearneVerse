import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/community_members_api_service.dart';
import 'community_members_state.dart';

class CommunityMembersCubit extends Cubit<CommunityMembersStates> {
  final CommunityMembersApiService communityMembersApiService;

  CommunityMembersCubit(this.communityMembersApiService)
      : super(CommunityMembersInitial());

  Future<void> fetchCommunityMembers(int communityId) async {
    emit(CommunityMembersLoading());
    try {
      final members =
          await communityMembersApiService.fetchCommunityMembers(communityId);
      emit(CommunityMembersSuccess(members));
    } catch (e) {
      emit(CommunityMembersError(e.toString()));
    }
  }
}
