import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/auth_api_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthApiService authApiService;

  AuthCubit(this.authApiService) : super(AuthInitial());

  void login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authApiService.login(email: email, password: password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
