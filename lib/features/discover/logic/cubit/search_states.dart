import '../../../community/data/models/community_members_model.dart';
import '../../../home/data/models/community_model.dart';

abstract class SearchStates {}

class SearchInitial extends SearchStates {}

class SearchLoading extends SearchStates {}

class SearchLoaded extends SearchStates {
  final List<Community> communities;
  final List<CommunityMember> users;
  SearchLoaded(this.communities, this.users);
}

class SearchError extends SearchStates {
  final String message;
  SearchError(this.message);
}