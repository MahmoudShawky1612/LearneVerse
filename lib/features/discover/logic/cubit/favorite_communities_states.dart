import '../../../home/data/models/community_model.dart';

abstract class FavoriteStates {}

class FavoriteInitial extends FavoriteStates {}

class FavoriteLoading extends FavoriteStates {}

class FavoriteLoaded extends FavoriteStates {
  final List<Community> communities;
  FavoriteLoaded(
    this.communities,
  );
}

class FavoriteError extends FavoriteStates {
  final String message;
  FavoriteError(this.message);
}
