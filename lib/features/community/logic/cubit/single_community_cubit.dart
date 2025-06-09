import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/community/logic/cubit/single_community_states.dart';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';

import '../../services/single_community_service.dart';

class SingleCommunityCubit extends Cubit<SingleCommunityStates> {
  final SingleCommunityApiService singleCommunityApiService;

  SingleCommunityCubit(this.singleCommunityApiService) : super(SingleCommunityInitial());

  void fetchSingleCommunity(int communityId) async {
    emit(SingleCommunityLoading());
    try {
      final Community community = await singleCommunityApiService.fetchSingleCommunity(communityId);
      emit(SingleCommunitySuccess(community));
    } catch (e) {
      emit(SingleCommunityFailure(e.toString()));
    }
  }


}
