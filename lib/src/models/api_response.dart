import 'dart:convert';
import 'package:flutter/foundation.dart';

/// [ApiResponse] is the API data model to save and retrieve from local disk
class ApiResponse {
  /// [ApiResponse] is the API data model to save and retrieve from local disk
  ApiResponse({
    required this.body,
    required this.baseUrl,
    required this.path,
    required this.method,
    required this.statusCode,
    required this.connectionTimeout,
    required this.contentType,
    required this.headers,
    // required this.headersMap,
    required this.queryParameters,
    // required this.queryParametersMap,
    required this.receiveTimeout,
    required this.request,
    required this.requestSize,
    required this.requestTime,
    required this.responseSize,
    required this.responseTime,
    required this.responseType,
    required this.sendTimeout,
    required this.checked,
    required this.clientLibrary,
  });

  /// Convert JSON to [ApiResponse]
  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        body: json['body'] as dynamic,
        baseUrl: json['baseUrl'] as String,
        method: json['method'] as String,
        statusCode: json['statusCode'] as int,
        connectionTimeout: json['connectionTimeout'] as int,
        contentType: json['contentType'] as String?,
        headers: _parseMap(json['headers']),
        queryParameters: _parseMap(json['queryParameters']),
        receiveTimeout: json['receiveTimeout'] as int,
        request: json['request'] as dynamic,
        requestSize: (json['requestSize'] as num).toDouble(),
        requestTime: DateTime.parse(json['requestTime'] as String),
        responseSize: (json['responseSize'] as num).toDouble(),
        responseTime: DateTime.parse(json['responseTime'] as String),
        responseType: json['responseType'] as String,
        sendTimeout: json['sendTimeout'] as int,
        path: json['path'] as String,
        checked: json['checked'] as bool? ?? false,
        clientLibrary: (json['clientLibrary'] as String?) ?? 'N/A',
      );

  /// Helper function to parse JSON strings into a Map<String, String>
  static Map<String, String> _parseMap(dynamic jsonString) {
    if (jsonString is String && jsonString.isNotEmpty && jsonString != '{}') {
      try {
        final Map<String, dynamic> parsed =
            jsonDecode(jsonString) as Map<String, dynamic>;
        return parsed.map((key, value) => MapEntry(key, value.toString()));
      } catch (e) {
        debugPrint('Failed to parse JSON: $e');
        return {};
      }
    } else if (jsonString is Map<String, dynamic>) {
      return jsonString.map((key, value) => MapEntry(key, value.toString()));
    } else {
      return {};
    }
  }

  /// Helper function to parse JSON strings into a Map<String, String>
  // static Map<String, String> _parseMap(String jsonString) {
  //   if (jsonString.isEmpty || jsonString == '{}') {
  //     return {};
  //   }
  //   try {
  //     final Map<String, dynamic> parsed =
  //         jsonDecode(jsonString) as Map<String, dynamic>;
  //     return parsed.map((key, value) => MapEntry(key, value.toString()));
  //   } catch (e) {
  //     debugPrint('Failed to parse JSON: $e');
  //     return {};
  //   }
  // }

  /// Mocked instance of [ApiResponse]. ***ONLY FOR TESTING****
  factory ApiResponse.mock() => ApiResponse(
        body: {'': ''},
        baseUrl: '',
        path: '',
        method: 'GET',
        statusCode: 200,
        connectionTimeout: 0,
        contentType: 'application/json',
        // headers: '',
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': '*',
        },
        // queryParameters: '',
        queryParameters: {},
        receiveTimeout: 0,
        request: {'': ''},
        requestSize: 0,
        requestTime: DateTime.now(),
        responseSize: 0,
        responseTime: DateTime.now(),
        responseType: 'json',
        sendTimeout: 0,
        checked: false,
        clientLibrary: '',
      );

  /// DateTime when request is sent
  final DateTime requestTime;

  /// DateTime when response is received
  final DateTime responseTime;

  /// Request base url, it can contain sub path.
  final String baseUrl;

  /// API end-point
  final String path;

  /// HTTP method such as `GET`
  final String method;

  /// HTTP status code. For more details, visit [https://developer.mozilla.org/en-US/docs/Web/HTTP/Status]
  final int statusCode;

  /// Size of request data
  final double requestSize;

  /// Size of response data
  final double responseSize;

  /// Request data
  final dynamic request;

  /// Response data
  final dynamic body;

  /// Request data type
  final String? contentType;

  /// Request headers
  // final String headers;

  /// Headers parsed as a Map<String, String>
  final Map<String, String> headers;

  /// Timeout in milliseconds for sending data
  final int sendTimeout;

  /// Response data type
  final String responseType;

  /// Timeout in milliseconds for receiving data
  final int receiveTimeout;

  /// Request query params
  // final String queryParameters;

  /// Query parameters parsed as a Map<String, String>
  final Map<String, dynamic> queryParameters;

  /// Timeout in milliseconds for making connection
  final int connectionTimeout;

  /// To check whether user has selected this instance or not
  final bool checked;

  /// The client which is used for network call
  final String clientLibrary;

  /// Convert [ApiResponse] to JSON.
  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'connectionTimeout': connectionTimeout,
      'contentType': contentType,
      'headers': headers,
      // 'headersMap': headersMap,
      'method': method,
      'queryParameters': queryParameters,
      // 'queryParametersMap': queryParametersMap,
      'receiveTimeout': receiveTimeout,
      'request': request,
      'requestSize': requestSize,
      'requestTime': requestTime.toIso8601String(),
      'responseSize': responseSize,
      'responseTime': responseTime.toIso8601String(),
      'responseType': responseType,
      'sendTimeout': sendTimeout,
      'statusCode': statusCode,
      'baseUrl': baseUrl,
      'path': path,
      'checked': checked,
      'clientLibrary': clientLibrary,
    };
  }

  /// Copies current data and returns new object
  ApiResponse copyWith({
    DateTime? requestTime,
    DateTime? responseTime,
    String? baseUrl,
    String? path,
    String? method,
    int? statusCode,
    double? requestSize,
    double? responseSize,
    dynamic request,
    String? response,
    dynamic body,
    String? contentType,
    // String? headers,
    Map<String, String>? headers,
    int? sendTimeout,
    String? responseType,
    int? receiveTimeout,
    // String? queryParameters,
    Map<String, dynamic>? queryParametersMap,
    int? connectionTimeout,
    bool? checked,
    String? clientLibrary,
  }) {
    return ApiResponse(
      body: body ?? this.body,
      baseUrl: baseUrl ?? this.baseUrl,
      path: path ?? this.path,
      method: method ?? this.method,
      statusCode: statusCode ?? this.statusCode,
      connectionTimeout: connectionTimeout ?? this.connectionTimeout,
      contentType: contentType ?? this.contentType,
      // headers: headers ?? this.headers,
      headers: headers ?? this.headers,
      // queryParameters: queryParameters ?? this.queryParameters,
      queryParameters: queryParametersMap ?? this.queryParameters,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      request: request ?? this.request,
      requestSize: requestSize ?? this.requestSize,
      requestTime: requestTime ?? this.requestTime,
      responseSize: responseSize ?? this.responseSize,
      responseTime: responseTime ?? this.responseTime,
      responseType: responseType ?? this.responseType,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      checked: checked ?? this.checked,
      clientLibrary: clientLibrary ?? this.clientLibrary,
    );
  }

  @override
  String toString() {
    return '''
***************** Overview *****************
Base URL: $baseUrl
Path: $path
Method: $method
Status Code: $statusCode
Request Time: $requestTime
Response Time: $responseTime
Headers: $headers
Query Params: $queryParameters
Content Type: $contentType
Response Type: $responseType
Connection Timeout: $connectionTimeout ms
Receive Timeout: $receiveTimeout ms
Send Timeout: $sendTimeout ms
Client Library: $clientLibrary

***************** Request *****************

$prettyJsonRequest

***************** Response *****************

$prettyJson''';
  }

  /// Formatted JSON response string
  String get prettyJson {
    return const JsonEncoder.withIndent('     ').convert(body);
  }

  /// Formatted JSON request string
  String get prettyJsonRequest {
    return const JsonEncoder.withIndent('     ').convert(request);
  }

  /// Headers parsed as a Map<String, String>
  // Map<String, String> get headersMap {
  //   debugPrint('Headers: $headers'); // Tambahkan ini untuk debugging
  //   try {
  //     final Map<String, dynamic> parsed =
  //         jsonDecode(headers) as Map<String, dynamic>;
  //     return parsed.map((key, value) => MapEntry(key, value.toString()));
  //   } catch (e) {
  //     debugPrint('Failed to parse headers: $e');
  //     return {};
  //   }
  // }

  // Map<String, String> get queryParametersMap {
  //   debugPrint(
  //       'Query Parameters: $queryParameters'); // Tambahkan ini untuk debugging
  //   try {
  //     final Map<String, dynamic> parsed =
  //         jsonDecode(queryParameters) as Map<String, dynamic>;
  //     return parsed.map((key, value) => MapEntry(key, value.toString()));
  //   } catch (e) {
  //     debugPrint('Failed to parse query parameters: $e');
  //     return {};
  //   }
  // }

  @override
  bool operator ==(Object other) =>
      other is ApiResponse && other.requestTime == requestTime;

  @override
  int get hashCode => requestTime.millisecondsSinceEpoch;
}
