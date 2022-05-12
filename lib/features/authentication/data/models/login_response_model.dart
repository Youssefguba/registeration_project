class LoginResponseModel {
  final String token;

  LoginResponseModel(this.token);

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(json['token']);
  }
}
