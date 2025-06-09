import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/discover/logic/cubit/toggle_states.dart';

import '../../services/toggle_service.dart';


class ToggleCubit extends Cubit<ToggleStates> {
  final ToggleService toggleService;
  ToggleCubit(this.toggleService) : super(ToggleInitial());

  Future<void> toggleToggleCommunity(int communityId) async {
    emit(ToggleLoading());
    try {
      await toggleService.toggleFavoriteCommunity(communityId);
      emit(ToggleToggled());
    } catch (e) {
      emit(ToggleError(e.toString()));
    }
  }
}