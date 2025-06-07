import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/classroom_service.dart';
 import 'classroom_states.dart';

class ClassroomCubit extends Cubit<ClassroomStates> {
  final ClassroomService _service;
  ClassroomCubit(this._service) : super(ClassroomInitial());

  Future<void> fetchClassrooms(int communityId) async {
    emit(ClassroomLoading());
    try {
      final classrooms = await _service.fetchClassroomsForACommunity(communityId: communityId);
      emit(ClassroomLoaded(classrooms));
    } catch (e) {
      emit(ClassroomError(e.toString()));
    }
  }
}
