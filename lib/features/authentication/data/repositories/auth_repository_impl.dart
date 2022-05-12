import 'dart:developer';

import 'package:signup_project_task/core/network/api_response_model.dart';

import '../../auth.export.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final UserLocalDataSource _userLocalDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource, this._userLocalDataSource);

  @override
  Future<ApiResponse<LoginResponseModel>> loginByEmail(
    String username,
    String password,
  ) async {
    final ApiResponse<LoginResponseModel> _response =
        await _authRemoteDataSource.loginByEmail(username, password);

    final loginResponse = LoginResponseModel.fromJson(_response.data);
    _userLocalDataSource.cacheUserToken(loginResponse.token);

    return _response;
  }

  @override
  Future<ApiResponse<UserModel>> signUpByEmail(
    String email,
    String username,
    String password,
    String phone,
    String address,
  ) async {
    final ApiResponse<UserModel> _response = await _authRemoteDataSource
        .signUpByEmail(email, username, password, phone, address);

    final userResponse = UserModel.fromJson(_response.data);
    _userLocalDataSource.cacheUserData(userResponse);
    return _response;
  }
}
