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
[
     {
          "key": "123"
     },
     {
          "file": "a.png"
     }
]''';

    final responses = await sharedPreferencesManager.getAllApiResponses();

    expect(responses.first.prettyJsonRequest, prettyJson);
  });

  test('Should handle multiple concurrent requests', () async {
    SharedPreferences.setMockInitialValues({});

    await Future.wait([
      dio.get<dynamic>(successPath),
      dio.get<dynamic>(successPath),
      dio.get<dynamic>(successPath),
    ]);

    final responses = await sharedPreferencesManager.getAllApiResponses();
    expect(responses.length, 3);
  });

  test('Should handle different HTTP methods', () async {
    SharedPreferences.setMockInitialValues({});

    dioAdapter
      ..onPut('/test', (s) => s.reply(200, {'status': 'updated'}))
      ..onDelete('/test', (s) => s.reply(200, {'status': 'deleted'}))
      ..onPatch('/test', (s) => s.reply(200, {'status': 'patched'}));

    await dio.put<dynamic>('/test');
    await dio.delete<dynamic>('/test');
    await dio.patch<dynamic>('/test');

    final responses = await sharedPreferencesManager.getAllApiResponses();
    expect(responses.length, 3);
    expect(responses.any((r) => r.method == 'PUT'), true);
    expect(responses.any((r) => r.method == 'DELETE'), true);
    expect(responses.any((r) => r.method == 'PATCH'), true);
  });

  test('Should handle request with headers', () async {
    SharedPreferences.setMockInitialValues({});

    await dio.get<dynamic>(
      successPath,
      options: Options(
        headers: {'Authorization': 'Bearer token123'},
      ),
    );

    final responses = await sharedPreferencesManager.getAllApiResponses();
    expect(responses.length, 1);
    expect(responses.first.headers.containsKey('Authorization'), true);
  });

  test('Should handle request with query parameters', () async {
    SharedPreferences.setMockInitialValues({});

    dioAdapter.onGet(
      '/test',
      (s) => s.reply(200, {'result': 'ok'}),
      queryParameters: {'page': '1', 'limit': '10'},
    );

    await dio.get<dynamic>(
      '/test',
      queryParameters: {'page': '1', 'limit': '10'},
    );

    final responses = await sharedPreferencesManager.getAllApiResponses();
    expect(responses.length, 1);
  });

  test('Should handle empty response body', () async {
    SharedPreferences.setMockInitialValues({});

    dioAdapter.onGet('/empty', (s) => s.reply(204, null));

    await dio.get<dynamic>('/empty');

    final responses = await sharedPreferencesManager.getAllApiResponses();
    expect(responses.length, 1);
    expect(responses.first.statusCode, 204);
  });

  test('Should handle different status codes', () async {
    SharedPreferences.setMockInitialValues({});

    dioAdapter
      ..onGet('/created', (s) => s.reply(201, {'id': 1}))
      ..onGet('/notfound', (s) => s.reply(404, {'error': 'not found'}))
      ..onGet('/servererror',
          (s) => s.reply(500, {'error': 'server error'}),);

    await dio.get<dynamic>('/created');
    
    try {
      await dio.get<dynamic>('/notfound');
    } catch (e) {
      // Expected error
    }
    
    try {
      await dio.get<dynamic>('/servererror');
    } catch (e) {
      // Expected error
    }

    final responses = await sharedPreferencesManager.getAllApiResponses();
    expect(responses.length, 3);
    expect(responses.any((r) => r.statusCode == 201), true);
    expect(responses.any((r) => r.statusCode == 404), true);
    expect(responses.any((r) => r.statusCode == 500), true);
  });
}
