import '../../data/models/community_members_model.dart';

abstract class CommunityMembersStates {}

class CommunityMembersInitial extends CommunityMembersStates {}

class CommunityMembersLoading extends CommunityMembersStates {}

class CommunityMembersSuccess extends CommunityMembersStates {
  final List<CommunityMember> members;

  CommunityMembersSuccess(this.members);
}

class CommunityMembersError extends CommunityMembersStates {
  final String message;

  CommunityMembersError(this.message);
}
