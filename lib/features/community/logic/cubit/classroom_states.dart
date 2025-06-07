import '../../data/models/classroom_model.dart';

abstract class ClassroomStates {}

class ClassroomInitial extends ClassroomStates {}

class ClassroomLoading extends ClassroomStates {}

class ClassroomLoaded extends ClassroomStates {
  final List<Classroom> classrooms;
  ClassroomLoaded(this.classrooms);
}

class ClassroomError extends ClassroomStates {
  final String message;
  ClassroomError(this.message);
}
