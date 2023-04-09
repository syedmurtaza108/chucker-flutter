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
    const headers = 'bearer token';
    const queryParameters = 'userId:1';
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
}
