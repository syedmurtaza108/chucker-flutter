import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:chucker_flutter/src/helpers/constants.dart';
import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

///[ChuckerChopperInterceptor] adds support for `chucker_flutter` in Chopper
class ChuckerChopperInterceptor extends ResponseInterceptor {
  @override
  FutureOr<Response> onResponse(Response response) async {
    if (kDebugMode || ChuckerFlutter.showOnRelease) {
      ChuckerUiHelper.showNotification(
        method: response.base.request?.method ?? '',
        statusCode: response.statusCode,
        path: response.base.request?.url.path ?? '',
      );
      await _saveResponse(response);
    }
    return response;
  }

  Future<void> _saveResponse(Response response) async {
    dynamic responseBody = '';

    try {
      final body = utf8.decode(response.bodyBytes);
      responseBody = jsonDecode(body);
      // ignore: empty_catches
    } catch (e) {}

    await SharedPreferencesManager.getInstance().addApiResponse(
      ApiResponse(
        body: {'data': responseBody},
        path: response.base.request?.url.path ?? emptyString,
        baseUrl: response.base.request?.url.origin ?? emptyString,
        method: response.base.request?.method ?? emptyString,
        statusCode: response.statusCode,
        connectionTimeout: 0,
        contentType: _requestType(response),
        headers: response.base.headers.toString(),
        queryParameters:
            response.base.request?.url.queryParameters.toString() ??
                emptyString,
        receiveTimeout: 0,
        request: {'request': _requestBody(response)},
        requestSize: 2,
        requestTime: DateTime.now(),
        responseSize: 2,
        responseTime: DateTime.now(),
        responseType: response.base.headers['content-type'] ?? 'N/A',
        sendTimeout: 0,
        checked: false,
        clientLibrary: 'Chopper',
      ),
    );
  }

  String _requestType(Response response) {
    final contentTypes = response.base.request!.headers.entries
        .where((element) => element.key == 'content-type');

    return contentTypes.isEmpty ? 'N/A' : contentTypes.first.value;
  }

  dynamic _requestBody(Response response) {
    if (response.base.request is http.Request) {
      final request = response.base.request! as http.Request;
      return request.body.isNotEmpty ? request.bodyFields : emptyString;
    }
    return emptyString;
  }
}
