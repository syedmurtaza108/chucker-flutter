import 'dart:convert';
import 'dart:developer';

///Helps printing network request and response in aesthetic way
class Logger {
  Logger._();

  static const _jsonEncoder = JsonEncoder.withIndent('  ');

  static const _ansiReset = '\x1B[0m';
  static const _ansiYellow = '\x1B[33m';

  ///Logs formatted json
  static void json(String json, {bool isRequest = false}) {
    try {
      final prettyJson = _jsonEncoder.convert(jsonDecode(json));
      final emoji = isRequest ? '↗️' : '↘️';
      log('$emoji$_ansiYellow JSON');
      log('$_ansiYellow$prettyJson$_ansiReset');
    } catch (e) {
      log(e.toString());
    }
  }

  ///Log request
  static void request(String request) {
    log('↗️$_ansiYellow$request');
  }

  ///Log response
  static void response(String response) {
    log('↘️$_ansiYellow$response');
  }
}
