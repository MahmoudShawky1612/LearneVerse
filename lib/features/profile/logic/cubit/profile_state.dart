import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/jwt_helper.dart';
import '../../data/models/user_profile_model.dart';
import '../../services/profile_api_services.dart';


abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

