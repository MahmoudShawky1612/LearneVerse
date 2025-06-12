
abstract class CommunityRoleState {}

class CommunityRoleInitial extends CommunityRoleState {}

class CommunityRoleLoading extends CommunityRoleState {}

class CommunityRoleLoaded extends CommunityRoleState {
  final String? role;

  CommunityRoleLoaded({required this.role});
}

class CommunityRoleError extends CommunityRoleState {
  final String message;

  CommunityRoleError({required this.message});
}

abstract class JoinRequestsState {}

class JoinRequestsInitial extends JoinRequestsState {}

class JoinRequestsLoading extends JoinRequestsState {}

class JoinRequestsLoaded extends JoinRequestsState {
  final List<Map<String, dynamic>> requests;
  JoinRequestsLoaded({required this.requests});
}

class JoinRequestsError extends JoinRequestsState {
  final String message;
  JoinRequestsError({required this.message});
}