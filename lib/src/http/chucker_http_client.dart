import 'dart:convert';

import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

///`Chucker Flutter`'s wrapper for `http` library
class ChuckerHttpClient extends BaseClient {
  ///`Chucker Flutter`'s wrapper for `http` library
  ChuckerHttpClient(this._client);
  final Client _client;

  late DateTime _requestTime;

  ///[onRequest] allows you to manipulate your request before letting
  ///`Chucker Flutter` processing it. E.g. you can add your logger in the
  ///following way:
  ///
  ///```dart
  /// class ChildChuckerHttpClient extends ChuckerHttpClient {
  ///   ChildChuckerHttpClient(Client httpClient) : super(httpClient);
  ///
  ///   @override
  ///   BaseRequest onRequest(BaseRequest request) {
  ///     print(request.toString());
  ///     return request;
  ///   }
  /// }
  /// ```
  BaseRequest onRequest(BaseRequest request) {
    return request;
  }

  ///[onResponse] allows you to manipulate your response before letting
  ///`Chucker Flutter` processing it. E.g. you can add your logger in the
  ///following way:
  ///
  ///```dart
  /// class ChildChuckerHttpClient extends ChuckerHttpClient {
  ///   ChildChuckerHttpClient(Client httpClient) : super(httpClient);
  ///
  ///   @override
  ///   BaseResponse onResponse(BaseResponse response) {
  ///     print(response.toString());
  ///     return response;
  ///   }
  /// }
  /// ```
  BaseResponse onResponse(BaseResponse response) {
    return response;
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    _requestTime = DateTime.now();
    final interceptedRequest = onRequest(request);

    final stream = await _client.send(request);

    final interceptedResponse = onResponse(stream);

    ChuckerUiHelper.showNotification(
      method: interceptedRequest.method,
      statusCode: interceptedResponse.statusCode,
      path: interceptedRequest.url.path,
    );

    await _saveResponse(interceptedRequest, interceptedResponse);

    return interceptedResponse as StreamedResponse;
  }

  Future<void> _saveResponse(BaseRequest request, BaseResponse response) async {
    dynamic requestBody = '';
    dynamic responseBody = '';

    if (request is Request && request.contentLength > 0) {
      requestBody = request.bodyFields;
    }

    if (response is IOStreamedResponse) {
      final List<int> bytes = await response.stream.toBytes();

      try {
        responseBody = jsonDecode(utf8.decode(bytes));
      } catch (e, s) {
        debugPrint(s.toString());
      }
    }

    await SharedPreferencesManager.getInstance().addApiResponse(
      ApiResponse(
        body: {'data': responseBody},
        path: request.url.path,
        baseUrl: request.url.origin,
        method: request.method,
        statusCode: response.statusCode,
        connectionTimeout: 0,
        contentType: request.headers['Content-Type'],
        headers: request.headers.toString(),
        queryParameters: request.url.queryParameters.toString(),
        receiveTimeout: 0,
        request: {'request': requestBody},
        requestSize: request.contentLength?.toDouble() ?? 0,
        requestTime: _requestTime,
        responseSize: response.contentLength?.toDouble() ?? 0,
        responseTime: DateTime.now(),
        responseType: response.headers['content-type'] ?? 'N/A',
        sendTimeout: 0,
        checked: false,
        clientLibrary: 'Http',
      ),
    );
  }
}
