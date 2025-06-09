import '../../../community/data/models/community_members_model.dart';
import '../../../home/data/models/community_model.dart';

abstract class ToggleStates {}

class ToggleInitial extends ToggleStates {}

class ToggleLoading extends ToggleStates {}

class ToggleLoaded extends ToggleStates {
  ToggleLoaded();
}
class ToggleToggled extends ToggleStates {}

class ToggleError extends ToggleStates {
  final String message;
  ToggleError(this.message);
}