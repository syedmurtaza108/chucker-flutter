import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:dio/dio.dart';

///[ChuckerDioInterceptor] adds support for `chucker_flutter` in [Dio] library.
class ChuckerDioInterceptor extends Interceptor {
  late final DateTime _requestTime;
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
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    _saveResponse(response);
    ChuckerUiHelper.showNotification(
      method: response.requestOptions.method,
      statusCode: response.statusCode ?? -1,
      path: response.requestOptions.path,
    );
    handler.next(response);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    _saveError(err);
    ChuckerUiHelper.showNotification(
      method: err.requestOptions.method,
      statusCode: err.response?.statusCode ?? -1,
      path: err.requestOptions.path,
    );
    handler.next(err);
  }

  void _saveResponse(Response response) {
    SharedPreferencesManager.getInstance().addApiResponse(
      ApiResponse(
        body: response.data.toString(),
        path: response.requestOptions.path,
        baseUrl: response.requestOptions.baseUrl,
        method: response.requestOptions.method,
        statusCode: response.statusCode ?? -1,
        connectionTimeout: response.requestOptions.connectTimeout,
        contentType: response.requestOptions.contentType,
        headers: response.requestOptions.headers.toString(),
        queryParameters: response.requestOptions.queryParameters.toString(),
        receiveTimeout: response.requestOptions.receiveTimeout,
        request: response.requestOptions.data.toString(),
        requestSize: 2,
        requestTime: _requestTime,
        response: response.data.toString(),
        responseSize: 2,
        responseTime: DateTime.now(),
        responseType: response.requestOptions.responseType.name,
        sendTimeout: response.requestOptions.sendTimeout,
      ),
    );
  }

  void _saveError(DioError response) {
    SharedPreferencesManager.getInstance().addApiResponse(
      ApiResponse(
        body: response.error.toString(),
        path: response.requestOptions.path,
        baseUrl: response.requestOptions.baseUrl,
        method: response.requestOptions.method,
        statusCode: response.response?.statusCode ?? -1,
        connectionTimeout: response.requestOptions.connectTimeout,
        contentType: response.requestOptions.contentType,
        headers: response.requestOptions.headers.toString(),
        queryParameters: response.requestOptions.queryParameters.toString(),
        receiveTimeout: response.requestOptions.receiveTimeout,
        request: response.requestOptions.data.toString(),
        requestSize: 2,
        requestTime: _requestTime,
        response: response.error.toString(),
        responseSize: 2,
        responseTime: DateTime.now(),
        responseType: response.requestOptions.responseType.name,
        sendTimeout: response.requestOptions.sendTimeout,
      ),
    );
  }
}
