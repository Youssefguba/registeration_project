part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({
    required this.email,
    required this.password,
  });
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String phone;

  SignUpEvent({
    required this.email,
    required this.password,
    required this.username,
    required this.phone,
  });
}

class LogoutEvent extends AuthEvent {}

class LoginWithGoogle extends AuthEvent {}

