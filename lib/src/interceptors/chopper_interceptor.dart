import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chopper/chopper.dart';
import 'package:chucker_flutter/src/helpers/constants.dart';
import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:http/http.dart' as http;

///[ChuckerChopperInterceptor] adds support for `chucker_flutter` in Chopper
class ChuckerChopperInterceptor implements Interceptor {
  Future<void> _saveResponse(Response<dynamic> response, DateTime time) async {
    dynamic responseBody = '';

    try {
      final body = utf8.decode(response.bodyBytes);
      responseBody = jsonDecode(body);
      // ignore: empty_catches
    } catch (e) {}

    await SharedPreferencesManager.getInstance().addApiResponse(
      ApiResponse(
        body: responseBody,
        path: response.base.request?.url.path ?? emptyString,
        baseUrl: response.base.request?.url.origin ?? emptyString,
        method: response.base.request?.method ?? emptyString,
        statusCode: response.statusCode,
        connectionTimeout: 0,
        contentType: _requestType(response),
        headers: Map<String, dynamic>.from(response.base.headers),
        responseHeaders: {} ,
        queryParameters: response.base.request?.url.queryParameters ?? {},
        receiveTimeout: 0,
        request: _requestBody(response),
        requestSize: 2,
        requestTime: time,
        responseSize: 2,
        responseTime: DateTime.now(),
        responseType: response.base.headers['content-type'] ?? 'N/A',
        sendTimeout: 0,
        checked: false,
        clientLibrary: 'Chopper',
      ),
    );

    final method = response.base.request?.method ?? '';
    final statusCode = response.statusCode;
    final path = response.base.request?.url.path ?? '';

    log('ChuckerFlutter: $method:$path($statusCode) saved.');
  }

  String _requestType(Response<dynamic> response) {
    final contentTypes = response.base.request?.headers.entries
        .where((element) => element.key == 'content-type');

    return contentTypes?.isEmpty ?? false
        ? 'N/A'
        : contentTypes?.first.value ?? '';
  }

  dynamic _requestBody(Response<dynamic> response) {
    if (response.base.request is http.MultipartRequest) {
      return _separateFileObjects(
        response.base.request as http.MultipartRequest?,
      );
    }

    if (response.base.request is http.Request) {
      final request = response.base.request! as http.Request;
      return request.body.isNotEmpty ? _getRequestBody(request) : emptyString;
    }
    return emptyString;
  }

  dynamic _getRequestBody(http.Request request) {
    try {
      return jsonDecode(request.body);
      // ignore: empty_catches
    } catch (e) {}
  }

  dynamic _separateFileObjects(http.MultipartRequest? request) {
    if (request == null) return emptyString;
    final formFields =
        request.fields.entries.map((e) => {e.key: e.value}).toList()
          ..addAll(
            request.files.map(
              (e) => {e.field: e.filename ?? emptyString},
            ),
          );
    return formFields;
  }

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final response = await chain.proceed(chain.request);
    final time = DateTime.now();
    await SharedPreferencesManager.getInstance().getSettings();

    if (ChuckerFlutter.isDebugMode || ChuckerFlutter.showOnRelease) {
      ChuckerUiHelper.showNotification(
        method: response.base.request?.method ?? '',
        statusCode: response.statusCode,
        path: response.base.request?.url.path ?? '',
        requestTime: time,
      );
      await _saveResponse(response, time);
    }
    return response;
  }
}
