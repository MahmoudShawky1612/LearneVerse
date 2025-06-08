// create_join_request_state.dart


import '../../data/models/creat_request_model.dart';

abstract class CreateJoinRequestStates{}

class CreateJoinRequestInitial extends CreateJoinRequestStates {}

class CreateJoinRequestLoading extends CreateJoinRequestStates {}

class CreateJoinRequestSuccess extends CreateJoinRequestStates{
  final CreateRequestResponse joinRequest;

   CreateJoinRequestSuccess(this.joinRequest);
}

class CreateJoinRequestError extends CreateJoinRequestStates {
  final String error;

   CreateJoinRequestError(this.error);

}
