import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/data/models/community_model.dart';
 import 'favorite_communities_states.dart';
 import '../../service/favorite_service.dart'; // your service

class FavoriteCubit extends Cubit<FavoriteStates> {
  final FavoriteService favoriteService;

  List<Community> _cachedCommunities = [];

  FavoriteCubit(this.favoriteService) : super(FavoriteInitial());

  Future<void> fetchFavoriteCommunities({bool forceRefresh = false}) async {

    if (_cachedCommunities.isNotEmpty && !forceRefresh) {
      emit(FavoriteLoaded(_cachedCommunities));
       return;
    }

    emit(FavoriteLoading());
    print("fetching favorite communities loading");
    try {
      final communities = await favoriteService.fetchFavoriteCommunities();

      if (!_areCommunitiesEqual(_cachedCommunities, communities)) {
        _cachedCommunities = communities;
        emit(FavoriteLoaded(communities));
      } else {
        emit(FavoriteLoaded(_cachedCommunities));
      }
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  void clearCache() {
    _cachedCommunities.clear();
  }

  bool _areCommunitiesEqual(List<Community> oldList, List<Community> newList) {
    if (oldList.length != newList.length) return false;
    for (int i = 0; i < oldList.length; i++) {
      if (oldList[i].id != newList[i].id) return false;
    }
    return true;
  }
}
