import 'dart:developer';

///Helps printing network request and response in aesthetic way
class Logger {
  Logger._();

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

  static void i(String message) {
    log('🙂$_ansiBlue$message$_ansiReset');
  }

  static void e(String message, {StackTrace? s}) {
    log('☹️$_ansiRed$message$_ansiReset', stackTrace: s);
  }

  static void w(String message) {
    log('🤨$_ansiYellow$message$_ansiReset');
  }

  static void g(String message) {
    log('🤨$_ansiGreen$message$_ansiReset');
  }

  static void json(String json) {
    log('↘️$_ansiYellow JSON');
    json.split('\n').forEach((e) {
      log('$_ansiYellow$e$_ansiReset');
    });
  }

  ///
  static void request(String request) {
    log('↗️$_ansiYellow$request');
  }
}
