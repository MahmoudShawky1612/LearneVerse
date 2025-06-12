import '../../../home/data/models/community_model.dart';

abstract class UserCommunitiesState {}

class UserCommunitiesInitial extends UserCommunitiesState {}

class UserCommunitiesLoading extends UserCommunitiesState {}

class UserCommunitiesLoaded extends UserCommunitiesState {
  final List<Community> communities;
  UserCommunitiesLoaded(this.communities);
}

class UserCommunitiesError extends UserCommunitiesState {
  final String message;
  UserCommunitiesError(this.message);
}

class UserCommunitiesActionSuccess extends UserCommunitiesState {
  final String message;
  UserCommunitiesActionSuccess(this.message);
}

class UserCommunitiesActionError extends UserCommunitiesState {
  final String message;
  UserCommunitiesActionError(this.message);
}
