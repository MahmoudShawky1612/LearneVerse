part of 'sections_cubit.dart';

abstract class SectionsState {}

class SectionsInitial extends SectionsState {}

class SectionsLoading extends SectionsState {}

class SectionsLoaded extends SectionsState {
  final List<SectionModel> sections;
  final List<LessonContent> lessons;
  final int? selectedSectionIndex;

  SectionsLoaded(this.sections, this.lessons, this.selectedSectionIndex);
}

class SectionsError extends SectionsState {
  final String message;
  SectionsError(this.message);
}
