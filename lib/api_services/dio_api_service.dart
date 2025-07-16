import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../app_constants.dart';
import 'dio_response_handler.dart';

class DioApiService {
  late Dio _dio;
  static DioApiService? _instance;

  /// Factory Constructor (Singleton)
  factory DioApiService() {
    _instance ??= DioApiService._internal();
    return _instance!;
  }

  /// Private Constructor
  DioApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: _buildHeaders(),
        validateStatus: (status) => true,
      ),
    );

    // Logging Interceptor for Debugging
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  /// **Build Headers**
  Map<String, String> _buildHeaders() {
    final headers = {
      'Content-Type': 'application/json',
    };
    return headers;
  }

  /// **Check Internet Connection Before API Calls**
  Future<bool> _isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// **GET Request with Optional Query Parameters**
  Future<Response> getRequest({
    required String endPoint,
    Map<String, dynamic>? queryParams,
    String? baseUrl,
  }) async {
    if (!await _isConnectedToInternet()) {
      throw DioError(
        requestOptions: RequestOptions(path: endPoint, baseUrl: baseUrl ?? Constants.baseUrl),
        error: "No Internet Connection.",
      );
    }
    try {
      final response = await _dio.get(
        '${Constants.baseUrl}$endPoint/',
        queryParameters: queryParams,
      );
      return response;
    } on DioError catch (e) {
      DioResponseHandler.handleDioError(e);
      rethrow;
    }
  }

  /// **POST Request**
  Future<Response> postRequest({
    required String endPoint,
    String? fullUrl,
    required Map<String, dynamic> data,
    bool mpmsBaseUrl = false,
    String? baseUrl,
  }) async {
    if (!await _isConnectedToInternet()) {
      throw DioError(
        requestOptions: RequestOptions(path: endPoint, baseUrl: Constants.baseUrl),
        error: "No Internet Connection.",
      );
    }

    try {
      final url = fullUrl ?? '${Constants.baseUrl}$endPoint/';
      final response = await _dio.post(
        url,
        data: jsonEncode(data),
      );
      return response;
    } on DioError catch (e) {
      DioResponseHandler.handleDioError(e);
      rethrow;
    }
  }
}
