import 'package:flutterwidgets/features/home/data/models/community_model.dart';

abstract class CommunityStates {}

class CommunityInitial extends CommunityStates {}

class CommunityLoading extends CommunityStates {}

class CommunitySuccess extends CommunityStates {
  final List<Community> communities;
  CommunitySuccess(this.communities);
}

class CommunityFailure extends CommunityStates {
  final String message;
  CommunityFailure(this.message);
}
