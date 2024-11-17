import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:food_app/utils/snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

/// Custom exception for API related errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() =>
      'ApiException: $message ${statusCode != null ? '($statusCode)' : ''}';
}

/// Response wrapper to standardize API responses
class ApiResponse<T> {
  final T? data;
  final bool success;
  final String? message;
  final int? statusCode;

  ApiResponse({
    this.data,
    required this.success,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {int? statusCode}) {
    return ApiResponse(
      data: data,
      success: true,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode, T? data}) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
      data: data,
    );
  }
}

/// Main API client class
class ApiClient {
  final String baseUrl;
  final Duration timeout;
  final int maxRetries;
  final Logger logger;
  final Map<String, String> defaultHeaders;

  ApiClient({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
    this.maxRetries = 3,
    Logger? logger,
    Map<String, String>? defaultHeaders,
  })  : logger = logger ?? Logger(),
        defaultHeaders = defaultHeaders ?? {};

  // Singleton instance
  static ApiClient? _instance;
  static ApiClient get instance {
    _instance ??= ApiClient(baseUrl: 'YOUR_BASE_URL');
    return _instance!;
  }

  /// Check internet connectivity
  Future<bool> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// Add auth token to headers
  Map<String, String> _addAuthHeader(
      Map<String, String>? headers, String? token) {
    final Map<String, String> allHeaders = Map.from(defaultHeaders);
    if (headers != null) {
      allHeaders.addAll(headers);
    }
    if (token != null) {
      allHeaders['Authorization'] = 'Bearer $token';
    }
    return allHeaders;
  }

  /// Handle HTTP response
  Future<ApiResponse<T>> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final body = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (body is Map<String, dynamic>) {
          return ApiResponse.success(
            fromJson(body),
            statusCode: response.statusCode,
          );
        }
        throw ApiException(
          message: 'Invalid response format',
          statusCode: response.statusCode,
          data: body,
        );
      }

      final message = body['message'] as String? ?? 'Unknown error occurred';
      throw ApiException(
        message: message,
        statusCode: response.statusCode,
        data: body,
      );
    } on FormatException {
      throw ApiException(
        message: 'Invalid response format',
        statusCode: response.statusCode,
      );
    }
  }

  /// Execute HTTP request with retry mechanism
  Future<ApiResponse<T>> _executeRequest<T>(
    Future<http.Response> Function() request,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    if (!await _checkConnectivity()) {
      return ApiResponse.error('No internet connection');
    }

    int attempts = 0;
    late ApiException lastError;

    while (attempts < maxRetries) {
      try {
        final response = await request().timeout(timeout);
        return await _handleResponse(response, fromJson);
      } on TimeoutException {
        lastError = ApiException(message: 'Request timed out');
      } on SocketException catch (e) {
        lastError = ApiException(
            message: 'Network error: Check your internet connection');
      } on ApiException catch (e) {
        // Don't retry if it's a client error (4xx)
        if (e.statusCode != null &&
            e.statusCode! >= 400 &&
            e.statusCode! < 500) {
          negativeMessage(message: e.message);
          rethrow;
        }
        lastError = e;
      } catch (e) {
        lastError = ApiException(message: 'Unexpected error: $e');
      }

      attempts++;
      if (attempts < maxRetries) {
        // Exponential backoff
        await Future.delayed(Duration(milliseconds: 1000 * attempts));
      }
    }

    logger.e(
      'Request failed after $maxRetries attempts',
      error: lastError,
    );
    negativeMessage(message: lastError.message);
    return ApiResponse.error(
      lastError.message,
      statusCode: lastError.statusCode,
    );
  }

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    String? token,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final uri = Uri.parse(baseUrl + endpoint).replace(
      queryParameters: queryParameters,
    );

    logger.d('GET Request: $uri');

    return _executeRequest(
      () => http.get(
        uri,
        headers: _addAuthHeader(headers, token),
      ),
      fromJson,
    );
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, String>? headers,
    String? token,
    Map<String, dynamic>? body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final uri = Uri.parse(baseUrl + endpoint);

    logger.d('POST Request: $uri');
    logger.d('Body: $body');

    return _executeRequest(
      () => http.post(
        uri,
        headers: _addAuthHeader(headers, token)
          ..addAll({
            'Content-Type': 'application/json',
          }),
        body: json.encode(body),
      ),
      fromJson,
    );
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, String>? headers,
    String? token,
    Map<String, dynamic>? body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final uri = Uri.parse(baseUrl + endpoint);

    logger.d('PUT Request: $uri');
    logger.d('Body: $body');

    return _executeRequest(
      () => http.put(
        uri,
        headers: _addAuthHeader(headers, token)
          ..addAll({
            'Content-Type': 'application/json',
          }),
        body: json.encode(body),
      ),
      fromJson,
    );
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
    String? token,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final uri = Uri.parse(baseUrl + endpoint);

    logger.d('DELETE Request: $uri');

    return _executeRequest(
      () => http.delete(
        uri,
        headers: _addAuthHeader(headers, token),
      ),
      fromJson,
    );
  }

  /// Upload file
  Future<ApiResponse<T>> uploadFile<T>(
    String endpoint,
    File file, {
    Map<String, String>? headers,
    String? token,
    String? fieldName,
    Map<String, String>? additionalFields,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final uri = Uri.parse(baseUrl + endpoint);
    final request = http.MultipartRequest('POST', uri);

    // Add headers
    request.headers.addAll(_addAuthHeader(headers, token));

    // Add file
    final fileStream = http.ByteStream(file.openRead());
    final fileLength = await file.length();
    final multipartFile = http.MultipartFile(
      fieldName ?? 'file',
      fileStream,
      fileLength,
      filename: file.path.split('/').last,
    );
    request.files.add(multipartFile);

    // Add additional fields
    if (additionalFields != null) {
      request.fields.addAll(additionalFields);
    }

    logger.d('UPLOAD Request: $uri');

    return _executeRequest(
      () async {
        final streamedResponse = await request.send();
        return await http.Response.fromStream(streamedResponse);
      },
      fromJson,
    );
  }
}

/// Usage example:
///
/// ```dart
/// // Initialize the client
/// final apiClient = ApiClient(
///   baseUrl: 'https://api.example.com',
///   timeout: Duration(seconds: 30),
///   maxRetries: 3,
/// );
///
/// // Make a request
/// final response = await apiClient.get<User>(
///   '/users/1',
///   fromJson: User.fromJson,
///   token: 'your-auth-token',
/// );
///
/// if (response.success) {
///   final user = response.data!;
///   print('User name: ${user.name}');
/// } else {
///   print('Error: ${response.message}');
/// }
/// ```
///
/// Don't forget to add these dependencies to your pubspec.yaml:
/// ```yaml
/// dependencies:
///   http: ^1.1.0
///   connectivity_plus: ^5.0.0
///   logger: ^2.0.0
/// ```