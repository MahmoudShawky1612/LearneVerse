import '../../data/models/contributions_model.dart';

abstract class UserContributionsState {}

class UserContributionsInitial extends UserContributionsState {}

class UserContributionsLoading extends UserContributionsState {}

class UserContributionsLoaded extends UserContributionsState {
  final List<UserContribution> contributions;
  UserContributionsLoaded(this.contributions);
}

class UserContributionsError extends UserContributionsState {
  final String message;
  UserContributionsError(this.message);
}
