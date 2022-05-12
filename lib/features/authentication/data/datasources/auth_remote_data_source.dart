import 'dart:convert';

import '../../../../core/network/network.export.dart';
import '../data.export.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResponse<LoginResponseModel>> loginByEmail(
      String username,
      String password,
      );
  Future<ApiResponse<UserModel>> signUpByEmail(
      String email,
      String username,
      String password,
      String phone,
      String address,
      );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkInterface _networkInterface;

  AuthRemoteDataSourceImpl(this._networkInterface);

  @override
  Future<ApiResponse<LoginResponseModel>> loginByEmail(
      String username,
      String password,
      ) async {
    final ApiResponse<LoginResponseModel> _response;
    _response = await _networkInterface.post(
      'auth/login',
      data: jsonEncode(
        <String, dynamic>{
          "username": username,
          "password": password,
        },
      ),
    );
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
    final ApiResponse<UserModel> _response;
    _response = await _networkInterface.post(
      'users',
      data: jsonEncode(
        <String, dynamic>{
          'email': email,
          'username': username,
          'password': password,
          'name': {'firstname': username, 'lastname': username},
          'address': {
            'city': 'Test City',
            'street': 'Test Street',
            'number': 'Test number',
            'zipcode': 'Test zipcode',
            'geolocation': {'lat': '-37.3159', 'long': '81.1496'}
          },
          'phone': phone
        },
      ),
    );
    return _response;
  }
}
