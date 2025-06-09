import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../community/data/models/community_members_model.dart';
import '../../../home/data/models/community_model.dart';
import '../../services/search_service.dart';
import 'search_states.dart';

class SearchCubit extends Cubit<SearchStates> {
  final SearchService _service;
  SearchCubit(this._service) : super(SearchInitial());

  Future<void> search({
    required String query,
    List<String>? tagNames,
    String? type,
  }) async {
    if (query.trim().isEmpty) {
      emit(SearchError('Search term is required'));
      return;
    }
    emit(SearchLoading());
    try {
      final result = await _service.search(
        query: query,
        tagNames: tagNames,
        type: type,
      );
      emit(SearchLoaded(result['communities'] as List<Community>, result['users'] as List<CommunityMember>));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}