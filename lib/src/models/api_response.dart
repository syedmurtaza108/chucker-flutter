import 'dart:convert';

///[ApiResponse] is the model to save and retrieve from shared preferences
class ApiResponse {
  ///[ApiResponse] is the model to save and retrieve from shared preferences
  ApiResponse({
    required this.body,
    required this.baseUrl,
    required this.path,
    required this.method,
    required this.statusCode,
    required this.connectionTimeout,
    required this.contentType,
    required this.headers,
    required this.queryParameters,
    required this.receiveTimeout,
    required this.request,
    required this.requestSize,
    required this.requestTime,
    required this.response,
    required this.responseSize,
    required this.responseTime,
    required this.responseType,
    required this.sendTimeout,
    required this.checked,
  });

  ///Convert json to [ApiResponse]
  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        body: json['body'] as Map<String, dynamic>,
        baseUrl: json['baseUrl'] as String,
        method: json['method'] as String,
        statusCode: json['statusCode'] as int,
        connectionTimeout: json['connectionTimeout'] as int,
        contentType: json['contentType'] as String?,
        headers: json['headers'] as String,
        queryParameters: json['queryParameters'] as String,
        receiveTimeout: json['receiveTimeout'] as int,
        request: json['request'] as Map<String, dynamic>,
        requestSize: json['requestSize'] as double,
        requestTime: DateTime.parse(json['requestTime'] as String),
        response: json['method'] as String,
        responseSize: json['responseSize'] as double,
        responseTime: DateTime.parse(json['responseTime'] as String),
        responseType: json['responseType'] as String,
        sendTimeout: json['sendTimeout'] as int,
        path: json['path'] as String,
        checked: json['checked'] as bool? ?? false,
      );

  ///requestTime
  final DateTime requestTime;

  ///responseTime
  final DateTime responseTime;

  ///url
  final String baseUrl;

  ///url
  final String path;

  ///method
  final String method;

  ///statusCode
  final int statusCode;

  ///requestSize
  final double requestSize;

  ///responseSize
  final double responseSize;

  ///request
  final Map<String, dynamic> request;

  ///response
  final String response;

  ///body
  final Map<String, dynamic> body;

  ///contentType
  final String? contentType;

  ///headers
  final String headers;

  ///sendTimeout
  final int sendTimeout;

  ///responseType
  final String responseType;

  ///receiveTimeout
  final int receiveTimeout;

  ///queryParameters
  final String queryParameters;

  ///connectionTimeout
  final int connectionTimeout;

  ///For selection purpose
  final bool checked;

  ///Convert [ApiResponse] to json.
  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'connectionTimeout': connectionTimeout,
      'contentType': contentType,
      'headers': headers,
      'method': method,
      'queryParameters': queryParameters,
      'receiveTimeout': receiveTimeout,
      'request': request,
      'requestSize': requestSize,
      'requestTime': requestTime.toIso8601String(),
      'response': response,
      'responseSize': responseSize,
      'responseTime': responseTime.toIso8601String(),
      'responseType': responseType,
      'sendTimeout': sendTimeout,
      'statusCode': statusCode,
      'baseUrl': baseUrl,
      'path': path,
      'checked': checked,
    };
  }

  ///Copies current data and returns new object
  ApiResponse copyWith({
    DateTime? requestTime,
    DateTime? responseTime,
    String? baseUrl,
    String? path,
    String? method,
    int? statusCode,
    double? requestSize,
    double? responseSize,
    Map<String, dynamic>? request,
    String? response,
    Map<String, dynamic>? body,
    String? contentType,
    String? headers,
    int? sendTimeout,
    String? responseType,
    int? receiveTimeout,
    String? queryParameters,
    int? connectionTimeout,
    bool? checked,
  }) {
    return ApiResponse(
      body: body ?? this.body,
      baseUrl: baseUrl ?? this.baseUrl,
      path: path ?? this.path,
      method: method ?? this.method,
      statusCode: statusCode ?? this.statusCode,
      connectionTimeout: connectionTimeout ?? this.connectionTimeout,
      contentType: contentType ?? this.contentType,
      headers: headers ?? this.headers,
      queryParameters: queryParameters ?? this.queryParameters,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      request: request ?? this.request,
      requestSize: requestSize ?? this.requestSize,
      requestTime: requestTime ?? this.requestTime,
      response: response ?? this.response,
      responseSize: responseSize ?? this.responseSize,
      responseTime: responseTime ?? this.responseTime,
      responseType: responseType ?? this.responseType,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      checked: checked ?? this.checked,
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
Request Time: ${requestTime.toString()}
Response Time: ${responseTime.toString()}
Headers: $headers
Query Params: $queryParameters
Content Type: $contentType
Response Type: $responseType
Connection Timeout: $connectionTimeout ms
Receive Timeout: $receiveTimeout ms
Send Timeout: $sendTimeout ms

***************** Request *****************

${jsonEncode(request)}

***************** Response *****************

${jsonEncode(body)}''';
  }
}
