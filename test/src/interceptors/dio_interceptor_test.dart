import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:dio/dio.dart';
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

  final formData = FormData.fromMap(
    {
      'key': '123',
      'file': MultipartFile.fromString('', filename: 'a.png'),
    },
  );

  setUpAll(() {
    _dio.interceptors.add(ChuckerDioInterceptor());
    _dioAdapter = DioAdapter(dio: _dio);
    _dio.httpClientAdapter = _dioAdapter;
    _sharedPreferencesManager = SharedPreferencesManager.getInstance();

    _dioAdapter
      ..onGet(_successPath, (s) => s.reply(200, _mockedSuccessResponse))
      ..onGet(_failPath, (s) => s.reply(400, _mockedErrorResponse))
      ..onPost(
        _successPath,
        (s) => s.reply(200, _mockedSuccessResponse),
        data: formData,
      );
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
      // ignore: empty_catches
    } catch (e) {}

    final responses = await _sharedPreferencesManager.getAllApiResponses();

    expect(responses.length, 1);
    expect(responses.first.statusCode, 400);
    expect(responses.first.body, {'data': _mockedErrorResponse});
  });

  test(
      'When UI is running in release mode and showOnRelease is false'
      ' notification should not be shown', () async {
    ChuckerFlutter.isDebugMode = false;

    //For success request
    await _dio.get(_successPath);
    expect(ChuckerUiHelper.notificationShown, false);

    //For failure request
    try {
      await _dio.get(_failPath);
      // ignore: empty_catches
    } catch (e) {}
    expect(ChuckerUiHelper.notificationShown, false);

    ChuckerFlutter.isDebugMode = true;
  });

  test(
      'When request has multippart body, its file details should be added'
      ' in api response model', () async {
    SharedPreferences.setMockInitialValues({});
    await _dio.post(_successPath, data: formData);

    const prettyJson = '''
{
     "request": [
          {
               "key": "123"
          },
          {
               "file": "a.png"
          }
     ]
}''';

    final responses = await _sharedPreferencesManager.getAllApiResponses();

    expect(responses.first.prettyJsonRequest, prettyJson);
  });
}
