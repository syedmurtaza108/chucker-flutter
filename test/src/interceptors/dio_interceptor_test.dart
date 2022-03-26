import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final _dio = Dio();
  late final SharedPreferencesManager _sharedPreferencesManager;

  late final DioAdapter _dioAdapter;

  const _mockedSuccessResponse = {'id': 1};
  const _mockedErrorResponse = {'email': 'email is invalid'};

  const _successPath = '/success';
  const _failPath = '/fail';

  setUpAll(() {
    _dio.interceptors.add(ChuckerDioInterceptor());
    _dioAdapter = DioAdapter(dio: _dio);
    _dio.httpClientAdapter = _dioAdapter;
    _sharedPreferencesManager = SharedPreferencesManager.getInstance();

    _dioAdapter
      ..onGet(_successPath, (s) => s.reply(200, _mockedSuccessResponse))
      ..onGet(_failPath, (s) => s.reply(400, _mockedErrorResponse));
  });

  test(
    'Response should be saved in shared preferences when call succeeds',
    () async {
      SharedPreferences.setMockInitialValues({});

      await _dio.get(_successPath);

      final responses = await _sharedPreferencesManager.getAllApiResponses();

      expect(responses.length, 1);
      expect(responses.first.statusCode, 200);
      expect(responses.first.body, {'data': _mockedSuccessResponse});
    },
  );

  test('Error should be saved in shared preferences when call fails', () async {
    SharedPreferences.setMockInitialValues({});

    try {
      await _dio.get(_failPath);
    } catch (e) {
      debugPrint('Dio error');
    }

    final responses = await _sharedPreferencesManager.getAllApiResponses();

    expect(responses.length, 1);
    expect(responses.first.statusCode, 400);
    expect(responses.first.body, {'data': _mockedErrorResponse});
  });
}
