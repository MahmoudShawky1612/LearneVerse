import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/discover/logic/cubit/favorite_communities_states.dart';
import 'package:flutterwidgets/features/discover/services/favorite_service.dart';


class FavoriteCubit extends Cubit<FavoriteStates> {
  final FavoriteService favoriteService;
  FavoriteCubit(this.favoriteService) : super(FavoriteInitial());

  Future<void> fetchFavoriteCommunities() async {
    emit(FavoriteLoading());
    try {
      final communities = await favoriteService.fetchFavoriteCommunities();
      emit(FavoriteLoaded(communities));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }
}