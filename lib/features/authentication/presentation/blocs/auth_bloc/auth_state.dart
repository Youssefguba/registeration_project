part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  loading,
  loginSuccess,
  loginFailure,
  accountNotFound,
  signupSuccess,
  signupFailure,
  logoutSuccess,
  logoutFailure,
}

class AuthState {
  final AuthStatus status;
  final String? email;
  AuthState(
    this.status, {
    this.email = '',
  });

  factory AuthState.initial() => AuthState(AuthStatus.initial);
  factory AuthState.loading() => AuthState(AuthStatus.loading);
  factory AuthState.loginSuccess() => AuthState(AuthStatus.loginSuccess);
  factory AuthState.loginFailure() => AuthState(AuthStatus.loginFailure);
  factory AuthState.accountNotFound() => AuthState(AuthStatus.accountNotFound);
  factory AuthState.signupSuccess() => AuthState(AuthStatus.signupSuccess);
  factory AuthState.signupFailure() => AuthState(AuthStatus.signupFailure);
  factory AuthState.logoutSuccess() => AuthState(AuthStatus.logoutSuccess);
  factory AuthState.logoutFailure() => AuthState(AuthStatus.logoutFailure);

  AuthState copyWith({
    AuthStatus? status,
    String? email,
  }) {
    return AuthState(
      status ?? this.status,
      email: email ?? this.email,
    );
  }
}
