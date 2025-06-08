

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/creat_request_model.dart';
import '../../services/join_requests_service.dart';
import 'join_requests_states.dart';

class CreateJoinRequestCubit extends Cubit<CreateJoinRequestStates> {
  final JoinRequestsService joinRequestsService;

  CreateJoinRequestCubit(this.joinRequestsService) : super(CreateJoinRequestInitial());

  Future<void> createJoinRequest(int communityId) async {
    emit(CreateJoinRequestLoading());
    try {
      final CreateRequestResponse joinRequest =
      await joinRequestsService.createJoinRequest(communityId);
      emit(CreateJoinRequestSuccess(joinRequest));
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(CreateJoinRequestError(errorMessage));
      // Optionally log the error for debugging
      print('Join request error: $errorMessage');
    }
  }
}