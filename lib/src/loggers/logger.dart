import 'dart:convert';
import 'dart:developer';

///Helps printing network request and response in aesthetic way
class Logger {
  Logger._();

  static const _jsonEncoder = JsonEncoder.withIndent('  ');

  static const tlCorner = '┌';
  static const blCorner = '└';
  static const mCorner = '├';
  static const line = '│';
  static const divider = '─';
  static const dashedDivider = '┄';

  static const _ansiReset = '\x1B[0m';
  static const _ansiRed = '\x1B[31m';
  static const _ansiGreen = '\x1B[32m';
  static const _ansiYellow = '\x1B[33m';
  static const _ansiBlue = '\x1B[34m';

  ///
  static void json(String json) {
    final prettyJson = _jsonEncoder.convert(jsonDecode(json));
    log('↘️$_ansiYellow JSON');
    // print(prettyJson.split('\n').length);
    log('$_ansiYellow$prettyJson$_ansiReset');
  }

  ///
  static void request(String request) {
    log('↗️$_ansiYellow$request');
  }

  ///
  static void response(String request) {
    log('↘️$_ansiYellow$request');
  }
}
