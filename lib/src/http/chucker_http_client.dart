import 'dart:convert';
import 'dart:developer';

import 'package:chucker_flutter/src/helpers/constants.dart';
import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:http/http.dart';

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
    await SharedPreferencesManager.getInstance().getSettings();

    final interceptedRequest = onRequest(request);

    final response = await _client.send(request);

    final bytes = await response.stream.toBytes();

    final interceptedResponse = onResponse(response);

    if (ChuckerFlutter.isDebugMode || ChuckerFlutter.showOnRelease) {
      ChuckerUiHelper.showNotification(
        method: interceptedRequest.method,
        statusCode: interceptedResponse.statusCode,
        path: interceptedRequest.url.path,
        requestTime: _requestTime,
      );

      await _saveResponse(
        interceptedRequest,
        bytes,
        response.statusCode,
        response.contentLength?.toDouble() ?? 0,
        response.headers['content-type'] ??
            response.headers['Content-Type'] ??
            'N/A',
      );
    }

    return StreamedResponse(
      ByteStream.fromBytes(bytes),
      response.statusCode,
      contentLength: response.contentLength,
      request: response.request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
  }

  Future<void> _saveResponse(
    BaseRequest request,
    List<int> bytes,
    int statusCode,
    double contentLength,
    String contentType,
  ) async {
    dynamic requestBody = '';
    dynamic responseBody = '';

    if (request is Request && request.contentLength > 0) {
      requestBody = _getRequestBody(request);
    }

    if (request is MultipartRequest) {
      requestBody = _separateFileObjects(request);
    }
    try {
      final a = utf8.decode(bytes);
      responseBody = jsonDecode(a);
      // ignore: empty_catches
    } catch (e) {}

    await SharedPreferencesManager.getInstance().addApiResponse(
      ApiResponse(
        body: responseBody,
        path: request.url.path,
        baseUrl: request.url.origin,
        method: request.method,
        statusCode: statusCode,
        connectionTimeout: 0,
        contentType: request.headers['Content-Type'],
        // headers: request.headers.toString(),
        headers: request.headers.cast<String, dynamic>(),
        responseHeaders: {},
        // queryParameters: request.url.queryParameters.toString(),
        queryParameters: request.url.queryParameters,
        receiveTimeout: 0,
        request: requestBody,
        requestSize: request.contentLength?.toDouble() ?? 0,
        requestTime: _requestTime,
        responseSize: contentLength,
        responseTime: DateTime.now(),
        responseType: contentType,
        sendTimeout: 0,
        checked: false,
        clientLibrary: 'Http',
      ),
    );

    final method = request.method;
    final path = request.url.path;

    log('ChuckerFlutter: $method:$path($statusCode) saved.');
  }

  dynamic _getRequestBody(Request request) {
    try {
      return jsonDecode(request.body);
      // ignore: empty_catches
    } catch (e) {}
  }

  dynamic _separateFileObjects(MultipartRequest request) {
    final formFields =
        request.fields.entries.map((e) => {e.key: e.value}).toList()
          ..addAll(
            request.files.map(
              (e) => {e.field: e.filename ?? emptyString},
            ),
          );
    return formFields;
  }
}
