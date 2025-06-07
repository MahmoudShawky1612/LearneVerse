import 'package:flutterwidgets/features/home/data/models/community_model.dart';


abstract class UpVoteCommentStates  {}

class UpVoteCommentInitial extends UpVoteCommentStates {}

class UpVoteCommentLoading extends UpVoteCommentStates {}

class UpVoteCommentSuccess extends UpVoteCommentStates {

}

class UpVoteCommentFailure extends UpVoteCommentStates {
  final String message;
  UpVoteCommentFailure(this.message);
}
