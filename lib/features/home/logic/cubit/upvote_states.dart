import 'package:flutterwidgets/features/home/data/models/community_model.dart';


abstract class UpVoteStates  {}

class UpVoteInitial extends UpVoteStates {}

class UpVoteLoading extends UpVoteStates {}

class UpVoteSuccess extends UpVoteStates {

}

class UpVoteFailure extends UpVoteStates {
  final String message;
  UpVoteFailure(this.message);
}
