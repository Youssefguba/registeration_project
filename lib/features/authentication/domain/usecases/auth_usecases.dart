import '../../../../core/network/network.export.dart';
import '../../auth.export.dart';

class AuthUseCases {
  final AuthRepository authRepository;

  AuthUseCases(this.authRepository);

  Future<ApiResponse<LoginResponseModel>> loginByEmail(
    String username,
    String password,
  ) async =>
      await authRepository.loginByEmail(username, password);

  Future<ApiResponse<UserModel>> signUpByEmail(
    String email,
    String username,
    String password,
    String phone,
    String address,
  ) async =>
      await authRepository.signUpByEmail(
          email, username, password, phone, address);
}
