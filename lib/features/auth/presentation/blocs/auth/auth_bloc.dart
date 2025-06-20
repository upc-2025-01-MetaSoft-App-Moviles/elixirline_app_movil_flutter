import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';
import '../../../data/repositories/auth_repository_impl.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('Login requested for: ${event.email}'); // Debug
    emit(AuthLoading());
    try {
      final user = await repository.login(event.email, event.password);
      print('Login result: $user'); // Debug
      if (user != null) {
        print('Emitting AuthAuthenticated'); // Debug
        emit(AuthAuthenticated(user));
      } else {
        print('Emitting AuthError - Invalid credentials'); // Debug
        emit(const AuthError('Credenciales incorrectas'));
      }
    } catch (e) {
      print('Login error: $e'); // Debug
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('Logout requested'); // Debug
    emit(AuthLoading());
    try {
      await repository.logout();
      print('Logout successful'); // Debug
      emit(AuthUnauthenticated());
    } catch (e) {
      print('Logout error: $e'); // Debug
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    print('Checking auth status'); // Debug
    emit(AuthLoading());
    try {
      final user = await repository.getCurrentUser();
      print('Current user: $user'); // Debug
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      print('Auth check error: $e'); // Debug
      emit(AuthUnauthenticated());
    }
  }
}
