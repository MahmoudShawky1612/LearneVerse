import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterwidgets/features/profile/logic/cubit/user_contributions.states.dart';
import '../../services/user_contributions_service.dart';

class UserContributionsCubit extends Cubit<UserContributionsState> {
  final UserContributionsApiService userContributionsApiService;

  UserContributionsCubit(this.userContributionsApiService) : super(UserContributionsInitial());

  void fetchContributionsByUser(int userId) async {
    emit(UserContributionsLoading());
    try {
      final contributions = await userContributionsApiService.fetchUserContributions(userId);
      emit(UserContributionsLoaded(contributions));
    } catch (e) {
      emit(UserContributionsError(e.toString()));
    }
  }
}