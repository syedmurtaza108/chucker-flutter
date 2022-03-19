import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

///[ApiResponse] is the model to save and retrieve from shared preferences
@JsonSerializable()
class ApiResponse {
  ///[ApiResponse] is the model to save and retrieve from shared preferences
  ApiResponse({
    required this.body,
    required this.url,
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
  });

  ///Convert json to [ApiResponse]
  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        body: json['body'] as String,
        url: json['url'] as String,
        method: json['method'] as String,
        statusCode: json['statusCode'] as int,
        connectionTimeout: json['connectionTimeout'] as int,
        contentType: json['contentType'] as String?,
        headers: json['headers'] as String,
        queryParameters: json['queryParameters'] as String,
        receiveTimeout: json['receiveTimeout'] as int,
        request: json['request'] as String,
        requestSize: json['requestSize'] as double,
        requestTime: DateTime.parse(json['requestTime'] as String),
        response: json['method'] as String,
        responseSize: json['responseSize'] as double,
        responseTime: DateTime.parse(json['responseTime'] as String),
        responseType: json['responseType'] as String,
        sendTimeout: json['sendTimeout'] as int,
      );

  ///requestTime
  final DateTime requestTime;

  ///responseTime
  final DateTime responseTime;

  ///url
  final String url;

  ///method
  final String method;

  ///statusCode
  final int statusCode;

  ///requestSize
  final double requestSize;

  ///responseSize
  final double responseSize;

  ///request
  final String request;

  ///response
  final String response;

  ///body
  final String body;

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
      'url': url,
    };
  }

  @override
  String toString() {
    return '$method:$url   $statusCode';
  }
}
