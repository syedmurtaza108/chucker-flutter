import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ApiResponse getMockedResponse() {
    const body = {'key': 'value'};
    const baseUrl = 'https://www.syedmurtaza.site';
    const path = 'api/get';
    const method = 'GET';
    const statusCode = 500;
    const connectionTimeout = -1;
    const contentType = 'xml';
    const headers = {'Content-Type': 'application/json'};
    const responseHeaders = <String, dynamic>{};
    const queryParameters = {'id': '1'};
    const receiveTimeout = -1;
    const request = {'id': '1'};
    const requestSize = 5.0;
    final requestTime = DateTime(2000);
    const responseSize = 5.0;
    final responseTime = DateTime(2001);
    const responseType = 'xml';
    const sendTimeout = -1;
    const checked = true;
    const clientLibrary = 'http';

    return ApiResponse(
      body: body,
      baseUrl: baseUrl,
      path: path,
      method: method,
      statusCode: statusCode,
      connectionTimeout: connectionTimeout,
      contentType: contentType,
      headers: headers,
      responseHeaders: responseHeaders,
      queryParameters: queryParameters,
      receiveTimeout: receiveTimeout,
      request: request,
      requestSize: requestSize,
      requestTime: requestTime,
      responseSize: responseSize,
      responseTime: responseTime,
      responseType: responseType,
      sendTimeout: sendTimeout,
      checked: checked,
      clientLibrary: clientLibrary,
    );
  }

  void equateApiResponses(
    ApiResponse response,
    ApiResponse mockedResponse,
  ) {
    expect(response.baseUrl, mockedResponse.baseUrl);
    expect(response.body, mockedResponse.body);
    expect(response.baseUrl, mockedResponse.baseUrl);
    expect(response.path, mockedResponse.path);
    expect(response.method, mockedResponse.method);
    expect(response.statusCode, mockedResponse.statusCode);
    expect(response.connectionTimeout, mockedResponse.connectionTimeout);
    expect(response.contentType, mockedResponse.contentType);
    expect(response.headers, mockedResponse.headers);
    expect(response.responseHeaders, mockedResponse.responseHeaders);
    expect(response.queryParameters, mockedResponse.queryParameters);
    expect(response.receiveTimeout, mockedResponse.receiveTimeout);
    expect(response.request, mockedResponse.request);
    expect(response.requestSize, mockedResponse.requestSize);
    expect(response.requestTime, mockedResponse.requestTime);
    expect(response.responseSize, mockedResponse.responseSize);
    expect(response.responseTime, mockedResponse.responseTime);
    expect(response.responseType, mockedResponse.responseType);
    expect(response.sendTimeout, mockedResponse.sendTimeout);
    expect(response.checked, mockedResponse.checked);
    expect(response.clientLibrary, mockedResponse.clientLibrary);
  }

  test('Two instances must be equal if their request times are equal', () {
    final time = DateTime.now();
    final model1 = ApiResponse.mock().copyWith(requestTime: time);
    final model2 = ApiResponse.mock().copyWith(requestTime: time);
    expect(model1, model2);
  });

  test('CopyWith should copy each attribute properly', () {
    final mockedResponse = getMockedResponse();
    final response = ApiResponse.mock().copyWith(
      body: mockedResponse.body,
      baseUrl: mockedResponse.baseUrl,
      path: mockedResponse.path,
      method: mockedResponse.method,
      statusCode: mockedResponse.statusCode,
      connectionTimeout: mockedResponse.connectionTimeout,
      contentType: mockedResponse.contentType,
      headers: mockedResponse.headers,
      responseHeaders: mockedResponse.responseHeaders,
      queryParameters: mockedResponse.queryParameters,
      receiveTimeout: mockedResponse.receiveTimeout,
      request: mockedResponse.request,
      requestSize: mockedResponse.requestSize,
      requestTime: mockedResponse.requestTime,
      responseSize: mockedResponse.responseSize,
      responseTime: mockedResponse.responseTime,
      responseType: mockedResponse.responseType,
      sendTimeout: mockedResponse.sendTimeout,
      checked: mockedResponse.checked,
      clientLibrary: mockedResponse.clientLibrary,
    );

    equateApiResponses(response, mockedResponse);
  });

  test('toJson should convert each attribute to its respective key', () {
    final response = getMockedResponse();

    final json = {
      'body': response.body,
      'baseUrl': response.baseUrl,
      'path': response.path,
      'method': response.method,
      'statusCode': response.statusCode,
      'connectionTimeout': response.connectionTimeout,
      'contentType': response.contentType,
      'headers': response.headers,
      'responseHeaders': response.responseHeaders,
      'queryParameters': response.queryParameters,
      'receiveTimeout': response.receiveTimeout,
      'request': response.request,
      'requestSize': response.requestSize,
      'requestTime': response.requestTime.toIso8601String(),
      'responseSize': response.responseSize,
      'responseTime': response.responseTime.toIso8601String(),
      'responseType': response.responseType,
      'sendTimeout': response.sendTimeout,
      'checked': response.checked,
      'clientLibrary': response.clientLibrary,
    };
    final toJson = response.toJson();

    expect(json, toJson);
  });

  test('fromJson should convert each key to its respective attribute', () {
    final mockedResponse = getMockedResponse();

    final toJson = mockedResponse.toJson();
    final response = ApiResponse.fromJson(toJson);
    equateApiResponses(response, mockedResponse);
  });

  test('toString should never return empty string', () {
    final mockedResponse = getMockedResponse();
    expect(mockedResponse.toString().isNotEmpty, true);
  });

  test('hashCode should return request time in milliseconds', () {
    final now = DateTime.now();
    final mockedResponse = getMockedResponse().copyWith(requestTime: now);
    expect(mockedResponse.hashCode, now.millisecondsSinceEpoch);
  });

  test('should handle null values in optional fields', () {
    final response = ApiResponse.mock().copyWith(
      body: null,
      contentType: null,
      responseType: null,
    );

    expect(response.body, null);
    expect(response.contentType, null);
    expect(response.responseType, null);
  });

  test('should handle empty maps and lists', () {
    final response = ApiResponse.mock().copyWith(
      body: {},
      headers: {},
      responseHeaders: {},
      queryParameters: {},
      request: {},
    );

    expect(response.body, {});
    expect(response.headers, {});
    expect(response.responseHeaders, {});
    expect(response.queryParameters, {});
    expect(response.request, {});
  });

  test('should handle large status codes', () {
    final response = ApiResponse.mock().copyWith(statusCode: 999);
    expect(response.statusCode, 999);
  });

  test('should handle negative timeouts', () {
    final response = ApiResponse.mock().copyWith(
      connectionTimeout: -1,
      receiveTimeout: -1,
      sendTimeout: -1,
    );

    expect(response.connectionTimeout, -1);
    expect(response.receiveTimeout, -1);
    expect(response.sendTimeout, -1);
  });

  test('should handle very long paths and URLs', () {
    const longPath = '/api/v1/very/long/path/with/many/segments/here';
    const longUrl = 'https://very.long.subdomain.example.com';

    final response = ApiResponse.mock().copyWith(
      path: longPath,
      baseUrl: longUrl,
    );

    expect(response.path, longPath);
    expect(response.baseUrl, longUrl);
  });

  test('should preserve checked state in copyWith', () {
    final response = ApiResponse.mock().copyWith(checked: true);
    expect(response.checked, true);

    final unchecked = response.copyWith(checked: false);
    expect(unchecked.checked, false);
  });

  test('should handle different HTTP methods', () {
    for (final method in ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD']) {
      final response = ApiResponse.mock().copyWith(method: method);
      expect(response.method, method);
    }
  });

  test('should serialize and deserialize with special characters', () {
    final response = ApiResponse.mock().copyWith(
      path: '/api/users?name=John&age=30',
      baseUrl: 'https://api.example.com',
    );

    final json = response.toJson();
    final deserialized = ApiResponse.fromJson(json);

    expect(deserialized.path, response.path);
    expect(deserialized.baseUrl, response.baseUrl);
  });

  test('should handle zero request and response sizes', () {
    final response = ApiResponse.mock().copyWith(
      requestSize: 0.0,
      responseSize: 0.0,
    );

    expect(response.requestSize, 0.0);
    expect(response.responseSize, 0.0);
  });
}
