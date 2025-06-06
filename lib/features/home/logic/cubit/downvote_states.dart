import 'package:flutterwidgets/features/home/data/models/community_model.dart';


abstract class DownVoteStates  {}

class DownVoteInitial extends DownVoteStates {}

class DownVoteLoading extends DownVoteStates {}

class DownVoteSuccess extends DownVoteStates {

}

class DownVoteFailure extends DownVoteStates {
  final String message;
  DownVoteFailure(this.message);
}
