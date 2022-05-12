import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:signup_project_task/core/cache/cache.export.dart';
import 'package:signup_project_task/features/authentication/domain/usecases/auth_usecases.dart';

import '../../../../../core/errors/exceptions.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCases _authUseCases;
  final SharedPrefsClient _sharedPrefsClient;

  String? email;

  AuthBloc(this._authUseCases, this._sharedPrefsClient)
      : super(AuthState(AuthStatus.initial)) {
    on<LoginEvent>((event, emit) async => await login(emit, event));
    on<SignUpEvent>((event, emit) async => await signup(emit, event));
    on<LogoutEvent>((event, emit) async => await logout(emit));
    on<LoginWithGoogle>((event, emit) async => await loginWithGoogle(emit));
  }

  Future<void> logout(Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));

      _sharedPrefsClient.clearUserData();
      emit(state.copyWith(status: AuthStatus.logoutSuccess));
    } on Exception catch (e) {
      emit(state.copyWith(status: AuthStatus.logoutFailure));
    }
  }

  Future<void> login(Emitter<AuthState> emit, LoginEvent event) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));

      await _authUseCases.loginByEmail(event.email, event.password);

      emit(state.copyWith(status: AuthStatus.loginSuccess, email: event.email));
    } on NotFoundException catch (e) {
      emit(state.copyWith(status: AuthStatus.accountNotFound));
    } on Exception catch (e) {
      emit(state.copyWith(status: AuthStatus.loginFailure));
    }
  }

  Future<void> signup(Emitter<AuthState> emit, SignUpEvent event) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      await _authUseCases.signUpByEmail(
          event.email, event.username, event.password, event.phone, '');
      email = event.email;
      emit(
          state.copyWith(status: AuthStatus.signupSuccess, email: event.email));
    } on Exception catch (e) {
      emit(state.copyWith(status: AuthStatus.signupFailure));
    }
  }

  Future<void> loginWithGoogle(Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));

      final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
      await googleUser!.clearAuthCache();

      emit(state.copyWith(
          status: AuthStatus.loginSuccess, email: googleUser.email));
    } catch (error) {
      emit(state.copyWith(status: AuthStatus.loginFailure));
    }
  }
}
