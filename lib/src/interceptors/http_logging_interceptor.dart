import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:chucker_flutter/src/loggers/logger.dart';
import 'package:http/http.dart' as http;

///Logs http request and response data
class ChuckerHttpLoggingInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final requestBase = await chain.request.toBaseRequest();
    Logger.request('${requestBase.method} ${requestBase.url}');
    requestBase.headers.forEach((k, v) => Logger.request('$k: $v'));

    var bytes = '';
    if (requestBase is http.Request) {
      final body = (requestBase as http.Request).body;
      if (body.isNotEmpty) {
        Logger.json(body, isRequest: true);
        bytes =
            ' (${(requestBase as http.Request).bodyBytes.length}-byte body)';
      }
    }

    Logger.request('END ${requestBase.method}$bytes');

    final response = await chain.proceed(chain.request);

    final base = response.base.request;
    Logger.response('${response.statusCode} ${base!.url}');

    response.base.headers.forEach((k, v) => Logger.response('$k: $v'));

    var responseBytes = '';
    if (response.base is http.Response) {
      final resp = response.base as http.Response;
      if (resp.body.isNotEmpty) {
        Logger.json(resp.body);
        responseBytes = ' (${response.bodyBytes.length}-byte body)';
      }
    }

    Logger.response('END ${base.method}$responseBytes');
    return response;
  }
}
