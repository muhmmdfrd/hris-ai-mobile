import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hris_ai/modules/auth/services/auth_service.dart' show LoginService;
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginService loginService;

  AuthBloc({required this.loginService}) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final token = await loginService.login(event.username, event.password);
      emit(AuthSuccess(token: token));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
