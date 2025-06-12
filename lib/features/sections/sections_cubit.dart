import 'package:flutter_bloc/flutter_bloc.dart';
import 'models.dart';
import 'api_service.dart';

part 'sections_state.dart';

class SectionsCubit extends Cubit<SectionsState> {
  SectionsCubit(sectionsApiService) : super(SectionsInitial());

  List<SectionModel> _sections = [];
  List<LessonContent> _lessons = [];
  int? _selectedSectionIndex;

  List<SectionModel> get sections => _sections;
  List<LessonContent> get lessons => _lessons;
  int? get selectedSectionIndex => _selectedSectionIndex;

  Future<void> loadSections(int classroomId) async {
    emit(SectionsLoading());
    try {
      _sections = await SectionsApiService.fetchSections(classroomId);
      if (_sections.isNotEmpty) {
        _selectedSectionIndex = 0;
        await loadLessons(_sections[0].id, emitLoading: false);
      }
      emit(SectionsLoaded(_sections, _lessons, _selectedSectionIndex));
    } catch (e) {
      emit(SectionsError(e.toString()));
    }
  }

  Future<void> loadLessons(int sectionId, {bool emitLoading = true}) async {
    if (emitLoading) emit(SectionsLoading());
    try {
      _lessons = await SectionsApiService.fetchLessons(sectionId);
      emit(SectionsLoaded(_sections, _lessons, _selectedSectionIndex));
    } catch (e) {
      emit(SectionsError(e.toString()));
    }
  }

  void selectSection(int index) async {
    if (index < 0 || index >= _sections.length) return;
    _selectedSectionIndex = index;
    await loadLessons(_sections[index].id);
  }

  Future<void> toggleLessonCompleted(int lessonId, int sectionId) async {
    emit(SectionsLoading());
    try {
      await SectionsApiService.toggleLessonCompleted(lessonId);
      await loadLessons(sectionId, emitLoading: false);
      emit(SectionsLoaded(_sections, _lessons, _selectedSectionIndex));
    } catch (e) {
      emit(SectionsError(e.toString()));
    }
  }
} 