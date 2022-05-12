/// [ApiResponse] represent the Response came from API that contain three
/// types of response:
/// - data: that contain data returned from API.
/// - statusCode: that contain status code of response {200, 404, 300, etc..}.
/// - message: that contain the exception/error message return from API.
class ApiResponse<T> {
  /// [data] used to contain data that returned from API.
  /// It is have a generic type for some reasons:
  /// - casting to any Model etc..
  late dynamic data;

  /// [statusCode] used to contain the returned Status Code from API.
  late int? statusCode;

  /// [message] used to return the error messages from the API or Exceptions.
  late String? message;

  ApiResponse({this.data, this.statusCode, this.message});

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    return ApiResponse<T>(
      statusCode: json["statusCode"],
      message: json["message"],
      data: create(json["data"]),
    );
  }
}
