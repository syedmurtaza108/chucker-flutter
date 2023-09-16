import 'dart:convert';
import 'dart:developer';

import 'package:chucker_flutter/src/helpers/constants.dart';
import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:dio/dio.dart';

///[ChuckerDioInterceptor] adds support for `chucker_flutter` in [Dio] library.
class ChuckerDioInterceptor extends Interceptor {
  late DateTime _requestTime;
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    _requestTime = DateTime.now();
    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    await SharedPreferencesManager.getInstance().getSettings();

    if (!ChuckerFlutter.isDebugMode && !ChuckerFlutter.showOnRelease) {
      handler.next(response);
      return;
    }

    final method = response.requestOptions.method;
    final statusCode = response.statusCode ?? -1;
    final path = response.requestOptions.path;

    ChuckerUiHelper.showNotification(
      method: method,
      statusCode: statusCode,
      path: path,
      requestTime: _requestTime,
    );

    await _saveResponse(response);

    log('ChuckerFlutter: $method:$path - $statusCode saved.');
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    await SharedPreferencesManager.getInstance().getSettings();

    if (!ChuckerFlutter.isDebugMode && !ChuckerFlutter.showOnRelease) {
      handler.next(err);
      return;
    }
    final method = err.requestOptions.method;
    final statusCode = err.response?.statusCode ?? -1;
    final path = err.requestOptions.path;

    ChuckerUiHelper.showNotification(
      method: method,
      statusCode: statusCode,
      path: path,
      requestTime: _requestTime,
    );
    await _saveError(err);

    log('ChuckerFlutter: $method:$path - $statusCode saved.');
    handler.next(err);
  }

  Future<void> _saveResponse(Response<dynamic> response) async {
    await SharedPreferencesManager.getInstance().addApiResponse(
      ApiResponse(
        body: response.data,
        path: response.requestOptions.path,
        baseUrl: response.requestOptions.baseUrl,
        method: response.requestOptions.method,
        statusCode: response.statusCode ?? -1,
        connectionTimeout:
            response.requestOptions.connectTimeout?.inMilliseconds ?? 0,
        contentType: response.requestOptions.contentType,
        headers: response.requestOptions.headers.toString(),
        queryParameters: response.requestOptions.queryParameters.toString(),
        receiveTimeout:
            response.requestOptions.receiveTimeout?.inMilliseconds ?? 0,
        request: _separateFileObjects(response.requestOptions).data,
        requestSize: 2,
        requestTime: _requestTime,
        responseSize: 2,
        responseTime: DateTime.now(),
        responseType: response.requestOptions.responseType.name,
        sendTimeout: response.requestOptions.sendTimeout?.inMilliseconds ?? 0,
        checked: false,
        clientLibrary: 'Dio',
      ),
    );
  }

  Map<String, dynamic> _getJson(String data) {
    try {
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  Future<void> _saveError(DioException response) async {
    await SharedPreferencesManager.getInstance().addApiResponse(
      ApiResponse(
        body: _getJson(response.response.toString()),
        path: response.requestOptions.path,
        baseUrl: response.requestOptions.baseUrl,
        method: response.requestOptions.method,
        statusCode: response.response?.statusCode ?? -1,
        connectionTimeout:
            response.requestOptions.connectTimeout?.inMilliseconds ?? 0,
        contentType: response.requestOptions.contentType,
        headers: response.requestOptions.headers.toString(),
        queryParameters: response.requestOptions.queryParameters.toString(),
        receiveTimeout:
            response.requestOptions.receiveTimeout?.inMilliseconds ?? 0,
        request: _separateFileObjects(response.requestOptions).data,
        requestSize: 2,
        requestTime: _requestTime,
        responseSize: 2,
        responseTime: DateTime.now(),
        responseType: response.requestOptions.responseType.name,
        sendTimeout: response.requestOptions.sendTimeout?.inMilliseconds ?? 0,
        checked: false,
        clientLibrary: 'Dio',
      ),
    );
  }

  RequestOptions _separateFileObjects(RequestOptions request) {
    if (request.data is! FormData) {
      return request;
    }

    final formData = request.data as FormData;
    final formFields = formData.fields.map((e) => {e.key: e.value}).toList()
      ..addAll(
        formData.files.map((e) => {e.key: e.value.filename ?? emptyString}),
      );
    return RequestOptions(path: request.path, data: formFields);
  }
}
