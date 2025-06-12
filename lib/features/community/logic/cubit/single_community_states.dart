import 'package:flutterwidgets/features/home/data/models/community_model.dart';

abstract class SingleCommunityStates {}

class SingleCommunityInitial extends SingleCommunityStates {}

class SingleCommunityLoading extends SingleCommunityStates {}

class SingleCommunitySuccess extends SingleCommunityStates {
  final Community community;
  SingleCommunitySuccess(this.community);
}

class SingleCommunityFailure extends SingleCommunityStates {
  final String message;
  SingleCommunityFailure(this.message);
}
