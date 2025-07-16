import 'package:dio/dio.dart';

class DioResponseHandler {
  /// Handles successful responses and errors properly
  static Map<String, dynamic> handleResponse(Response response) {
    if (response.statusCode == 500) {
      return _formatResponse("error", "Internal Server Error: Try again later.");
    }

    try {
      dynamic jsonBody = response.data; // Directly use Dio's parsed JSON
      return _processResponse(response.statusCode ?? 500, jsonBody);
    } catch (e) {
      return _formatResponse("error", "Invalid JSON response");
    }
  }

  /// Processes API responses based on status codes
  static Map<String, dynamic> _processResponse(int statusCode, dynamic jsonBody) {
    switch (statusCode) {
      case 200:
      case 201: // Created
        return _formatResponse("success", jsonBody?['message'] ?? "Success", jsonBody);

      case 204: // No Content
        return _formatResponse("success", "No content available");

      case 400: // Bad Request
        return _handleBadRequest(jsonBody);

      case 401: // Unauthorized
        return _formatResponse("error", jsonBody?['detail'] ?? "Unauthorized");

      case 403: // Forbidden
        return _formatResponse("error", jsonBody?['detail'] ?? "Access forbidden");

      case 404: // Not Found
        return _formatResponse("error", jsonBody?['message'] ?? "Resource not found");

      case 405: // Method Not Allowed
        return _formatResponse("error", "Method not allowed on this endpoint.");

      case 409: // Conflict
        return _formatResponse("error", jsonBody?['message'] ?? "Data conflict detected.");

      case 422: // Unprocessable Entity (Validation Errors)
        return _handleValidationErrors(jsonBody);

      case 502: // Bad Gateway
        return _formatResponse("error", "Bad Gateway: The server received an invalid response.");

      case 503: // Service Unavailable
        return _formatResponse("error", "Service is currently unavailable. Try again later.");

      case 504: // Gateway Timeout
        return _formatResponse("error", "The request timed out. Please try again.");

      default:
        return _formatResponse("error", jsonBody?['message'] ?? "Unexpected error occurred.");
    }
  }

  /// Handles 400 Bad Request errors with detailed messages
  static Map<String, dynamic> _handleBadRequest(dynamic jsonBody) {
    if (jsonBody != null &&
        (jsonBody.containsKey('errors') ||
            jsonBody.containsKey('detail') ||
            jsonBody.containsKey('message'))) {
      return _formatValidationErrors(jsonBody['errors']);
    }
    return _formatResponse("error", jsonBody?['message'] ?? "Invalid request data.");
  }

  /// Handles 422 Validation Errors
  static Map<String, dynamic> _handleValidationErrors(dynamic jsonBody) {
    if (jsonBody != null && jsonBody.containsKey('errors')) {
      return _formatValidationErrors(jsonBody['errors']);
    }
    return _formatResponse("error", jsonBody?['message'] ?? "Unprocessable entity.");
  }

  /// Formats validation errors into a readable message
  static Map<String, dynamic> _formatValidationErrors(Map<String, dynamic> errors) {
    String errorMessage =
        errors.entries.map((entry) => "${entry.key}: ${entry.value.join(', ')}").join('\n');
    return _formatResponse("error", errorMessage, errors);
  }

  /// Formats the API response into a standardized structure
  static Map<String, dynamic> _formatResponse(String status, String message, [dynamic data]) {
    return {"status": status, "message": message, if (data != null) "data": data};
  }

  /// Handles DioExceptions (Network, Timeout, and API Errors)
  static Map<String, dynamic> handleDioError(DioError e) {
    if (e.response != null) {
      return handleResponse(e.response!);
    }
    switch (e.type) {
      case DioError.connectionTimeout:
        return _formatResponse("error", "Connection Timeout. Please try again.");
      case DioError.receiveTimeout:
        return _formatResponse("error", "Server took too long to respond.");
      case DioError.sendTimeout:
        return _formatResponse("error", "Request timeout. Please try again.");
      case DioError.connectionError:
        return _formatResponse("error", "No Internet Connection.");
      case DioError.badResponse:
        return _formatResponse("error", "Bad Response.");
      default:
        return _formatResponse("error", "Unexpected error occurred: ${e.message}");
    }
  }
}
