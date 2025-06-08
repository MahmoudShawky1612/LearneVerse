
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