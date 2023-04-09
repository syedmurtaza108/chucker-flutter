import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final dio = Dio();
  late final SharedPreferencesManager sharedPreferencesManager;

  late final DioAdapter dioAdapter;

  const mockedSuccessResponse = {'id': 1};
  const mockedErrorResponse = {'email': 'email is invalid'};

  const successPath = '/success';
  const failPath = '/fail';

  final formData = FormData.fromMap(
    {
      'key': '123',
      'file': MultipartFile.fromString('', filename: 'a.png'),
    },
  );

  setUpAll(() {
    dio.interceptors.add(ChuckerDioInterceptor());
    dioAdapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = dioAdapter;
    sharedPreferencesManager = SharedPreferencesManager.getInstance(
      initData: false,
    );

    dioAdapter
      ..onGet(successPath, (s) => s.reply(200, mockedSuccessResponse))
      ..onGet(failPath, (s) => s.reply(400, mockedErrorResponse))
      ..onPost(
        successPath,
        (s) => s.reply(200, mockedSuccessResponse),
        data: formData,
      );
  });

  test(
    'Response should be saved in shared preferences when call succeeds',
    () async {
      SharedPreferences.setMockInitialValues({});

      await dio.get<dynamic>(successPath);

      final responses = await sharedPreferencesManager.getAllApiResponses();

      expect(responses.length, 1);
      expect(responses.first.statusCode, 200);
      expect(responses.first.body, mockedSuccessResponse);
    },
  );

  test('Error should be saved in shared preferences when call fails', () async {
    SharedPreferences.setMockInitialValues({});

    try {
      await dio.get<dynamic>(failPath);
      // ignore: empty_catches
    } catch (e) {}

    final responses = await sharedPreferencesManager.getAllApiResponses();

    expect(responses.length, 1);
    expect(responses.first.statusCode, 400);
    expect(responses.first.body, mockedErrorResponse);
  });

  test(
      'When UI is running in release mode and showOnRelease is false'
      ' notification should not be shown', () async {
    ChuckerFlutter.isDebugMode = false;

    //For success request
    await dio.get<dynamic>(successPath);
    expect(ChuckerUiHelper.notificationShown, false);

    //For failure request
    try {
      await dio.get<dynamic>(failPath);
      // ignore: empty_catches
    } catch (e) {}
    expect(ChuckerUiHelper.notificationShown, false);

    ChuckerFlutter.isDebugMode = true;
  });

  test(
      'When request has multippart body, its file details should be added'
      ' in api response model', () async {
    SharedPreferences.setMockInitialValues({});
    await dio.post<dynamic>(successPath, data: formData);

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

    final responses = await sharedPreferencesManager.getAllApiResponses();

    expect(responses.first.prettyJsonRequest, prettyJson);
  });
}
