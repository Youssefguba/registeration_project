import '../../../../core/network/network.export.dart';
import '../../data/data.export.dart';

abstract class AuthRepository {
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
