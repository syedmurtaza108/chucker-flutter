import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:chucker_flutter/src/loggers/logger.dart';
import 'package:http/http.dart' as http;

///Logs http request and response data
class ChuckerHttpLoggingInterceptor
    implements RequestInterceptor, ResponseInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) async {
    final base = await request.toBaseRequest();
    Logger.request('${base.method} ${base.url}');
    base.headers.forEach((k, v) => Logger.request('$k: $v'));

    var bytes = '';
    if (base is http.Request) {
      final body = base.body;
      if (body.isNotEmpty) {
        Logger.json(body, isRequest: true);
        bytes = ' (${base.bodyBytes.length}-byte body)';
      }
    }

    Logger.request('END ${base.method}$bytes');
    return request;
  }

  @override
  FutureOr<Response> onResponse(Response response) {
    final base = response.base.request;
    Logger.response('${response.statusCode} ${base!.url}');

    response.base.headers.forEach((k, v) => Logger.response('$k: $v'));

    var bytes = '';
    if (response.base is http.Response) {
      final resp = response.base as http.Response;
      if (resp.body.isNotEmpty) {
        Logger.json(resp.body);
        bytes = ' (${response.bodyBytes.length}-byte body)';
      }
    }

    Logger.response('END ${base.method}$bytes');
    return response;
  }
}
