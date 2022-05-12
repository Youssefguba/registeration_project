import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import 'network.export.dart';

abstract class NetworkInterface {
  /// [NetworkLinks] field that swap between base url when [get] url.
  Future<ApiResponse<T>> get<T>(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String? userToken,
  });

  /// [NetworkLinks] field that swap between base url when [post] link to
  /// [ABWAAB_URL_PRODUCTION] or [ABWAAB_MT_URL_PRODUCTION].
  Future<ApiResponse<T>> post<T>(
    String url, {
    String? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String? userToken,
  });
}

class NetworkImpl implements NetworkInterface {
  final Dio _dio;

  final Map<String, dynamic> _headers = {
    'Access-Control-Allow-Origin': '*',
    'Content-Type': 'application/json',
    'platform': 'android-app', // TODO(Youssef): Handle it on iOS.
  };

  NetworkImpl(this._dio) {
    _dio.options.baseUrl = BASE_URL;
    _dio.options.headers = _headers;
  }

  /// [get] Method of Network.
  ///
  /// The data and status code returned from Response saved to [ApiResponse].
  ///
  /// [get] method have 2 status:
  ///
  /// 1.Successful State:
  /// If the response is returned successfully, the [get] method will return
  /// [ApiResponse] model with needed data, statusCode of response.
  ///
  /// 2.Error State:
  /// If the response have a Network Error, the [get] method will return [ApiResponse]
  /// with (Null) data and statusCode of Response, And will throw an [Exception] also.
  ///
  @override
  Future<ApiResponse<T>> get<T>(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String? userToken,
  }) async {
    ApiResponse<T> _apiResponse = ApiResponse<T>();
    try {
      _requestHandler(headers, queryParameters, userToken);

      final Future<Response> getMethod = _dio.get(
        url,
        options: Options(headers: _headers),
        queryParameters: queryParameters,
      );

      _apiResponse = await _networkMethods(method: getMethod);
      return _apiResponse;
    } on DioError catch (e) {
      _apiResponse.statusCode = e.response!.statusCode;
      _apiResponse.data = e.response!.data;
      _apiResponse = await _responseHandler(_apiResponse);
      throw _apiResponse;
    }
  }

  /// [post] Method of Network.
  ///
  /// The data and status code returned from Response saved to [ApiResponse].
  ///
  /// [post] method have 2 status:
  ///
  /// 1.Successful State:
  /// If the response is returned successfully, the [get] method will return
  /// [ApiResponse] model with needed data, statusCode of response.
  ///
  /// 2.Error State:
  /// If the response have a Network Error, the [get] method will return [ApiResponse]
  /// with (Null) data and statusCode of Response, And will throw an [Exception] also.
  ///
  @override
  Future<ApiResponse<T>> post<T>(
    String url, {
    String? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String? userToken,
  }) async {
    ApiResponse<T> _apiResponse = ApiResponse<T>();
    try {
      _requestHandler(headers, queryParameters, userToken, data: data);

      final Future<Response> postMethod = _dio.post(
        url,
        data: data,
        options: Options(headers: _headers),
        queryParameters: queryParameters,
      );

      _apiResponse = await _networkMethods(method: postMethod);
      return _apiResponse;
    } on DioError catch (e) {
      _apiResponse.statusCode = e.response!.statusCode;
      _apiResponse.data = e.response!.data;
      _apiResponse = await _responseHandler(_apiResponse);
      throw _apiResponse;
    }
  }

  /// Generic Method of Network used for [get, post, put, delete, patch] Methods
  ///
  /// The data and status code returned from Response saved to [ApiResponse].
  ///
  /// [_networkMethods] method have 2 status:
  ///
  /// 1.Successful State:
  /// If the response is returned successfully, the [get] method will return
  /// [ApiResponse] model with needed data, statusCode of response.
  ///
  /// 2.Error State:
  /// If the response have a Network Error, the [get] method will return [ApiResponse]
  /// with (Null) data and statusCode of Response, And will throw an [Exception] also.
  ///
  Future<ApiResponse<T>> _networkMethods<T>({
    required Future<Response> method,
  }) async {
    ApiResponse<T> _apiResponse = ApiResponse<T>();
    try {
      // set the response of method [get, post] to response.
      final response = await method;
      _apiResponse.statusCode = response.statusCode;
      _apiResponse.data = response.data;
      _apiResponse = await _responseHandler(_apiResponse);


      return _apiResponse;
    } on DioError catch (e) {
      _traceError(e);
      _apiResponse.statusCode = e.response!.statusCode;
      _apiResponse.data = e.response!.data;
      _apiResponse = await _responseHandler(_apiResponse);
      throw _apiResponse;
    }
  }

  /// That responsible for handling the exceptions and error that thrown from api.
  Future<ApiResponse<T>> _responseHandler<T>(ApiResponse<T> response) async {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        return response;
      case 400:
        throw BadRequestException();
      case 404:
        throw NotFoundException();
      case 406:
        throw NotFoundException();
      case 422:
        throw BadRequestException();
      case 401:
        throw NotFoundException();
      case 403:
        throw UnAuthorizationException();
      case 500:
        throw ServerException();
      default:
        throw const SocketException('There is no Internet!');
    }
  }

  /// [_requestHandler] handle request [data, params, headers] that sent to Servers via Network.
  void _requestHandler(
    Map<String, dynamic>? headers,
    Map? params,
    String? userToken, {
    String? data,
  }) {
    data ??= "";
    if (headers != null) _headers.addAll(headers);
    params ??= {"": ""};
    if (userToken != null) _headers.addAll({"x-access-token": userToken});
  }

  void _traceError(DioError e) =>
      developer.log('════════════════════════════════════════ \n'
          '╔╣ Dio [ERROR] info ==> \n'
          '╟ BASE_URL: ${e.requestOptions.baseUrl}\n'
          '╟ PATH: ${e.requestOptions.path}\n'
          '╟ Method: ${e.requestOptions.method}\n'
          '╟ Params: ${e.requestOptions.queryParameters}\n'
          '╟ Body: ${e.requestOptions.data}\n'
          '╟ Header: ${e.requestOptions.headers}\n'
          '╟ statusCode: ${e.response!.statusCode}\n'
          '╟ RESPONSE: ${e.response!.data} \n'
          '╟ stackTrace: ${e.stackTrace} \n'
          '╚ [END] ════════════════════════════════════════╝');
}
