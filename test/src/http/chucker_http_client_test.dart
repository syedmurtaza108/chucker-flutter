import 'dart:convert';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late final ChuckerHttpClient _client;

  const _mockedSuccessResponse = {'id': 1};
  const _mockedErrorResponse = {'email': 'email is invalid'};

  const _baseUrl = 'https://www.example.com';
  const _successPath = '/success';
  const _failPath = '/fail';
  const _internalErrorPath = '/internal-error';

  final _mockClient = MockClient((request) async {
    if (request.url.path == _successPath) {
      return Response(jsonEncode(_mockedSuccessResponse), 200);
    }
    if (request.url.path == _internalErrorPath) {
      return Response(jsonEncode({'error': 'something went wrong'}), 500);
    }
    return Response(jsonEncode(_mockedErrorResponse), 400);
  });

  late final _MyChuckerHttpClient _myChuckerHttpClient;

  late final SharedPreferencesManager _sharedPreferencesManager;

  setUpAll(() {
    _client = ChuckerHttpClient(_mockClient);
    _sharedPreferencesManager = SharedPreferencesManager.getInstance();
    _myChuckerHttpClient = _MyChuckerHttpClient(_mockClient);
  });
  test('Response should be saved in shared preferences when call succeeds',
      () async {
    SharedPreferences.setMockInitialValues({});
    await _client.get(Uri.parse('$_baseUrl$_successPath'));

    final responses = await _sharedPreferencesManager.getAllApiResponses();

    expect(responses.length, 1);
    expect(responses.first.statusCode, 200);
    expect(responses.first.body, {'data': _mockedSuccessResponse});
  });

  test('Error should be saved in shared preferences when call fails', () async {
    SharedPreferences.setMockInitialValues({});
    await _client.get(Uri.parse('$_baseUrl$_failPath'));

    final responses = await _sharedPreferencesManager.getAllApiResponses();

    expect(responses.length, 1);
    expect(responses.first.statusCode, 400);
    expect(responses.first.body, {'data': _mockedErrorResponse});
  });

  test('Request data should be intercepted when user calls onRequest',
      () async {
    SharedPreferences.setMockInitialValues({});
    await _myChuckerHttpClient.get(Uri.parse('$_baseUrl$_successPath'));

    final responses = await _sharedPreferencesManager.getAllApiResponses();
    expect(responses.length, 1);
    expect(responses.first.headers, '{my-token: token}');
  });

  test('Response data should be accessible when user calls onResponse',
      () async {
    expect(_myChuckerHttpClient.statusCode, 200);
    SharedPreferences.setMockInitialValues({});
    await _myChuckerHttpClient.get(Uri.parse('$_baseUrl$_internalErrorPath'));

    final responses = await _sharedPreferencesManager.getAllApiResponses();
    expect(responses.length, 1);
    expect(_myChuckerHttpClient.statusCode, 500);
  });
  test(
      'When UI is running in release mode and showOnRelease is false'
      ' notification should not be shown', () async {
    ChuckerFlutter.isDebugMode = false;
    await _myChuckerHttpClient.get(Uri.parse('$_baseUrl$_internalErrorPath'));
    ChuckerFlutter.isDebugMode = true;
    expect(ChuckerUiHelper.notificationShown, false);
  });

  test('When request has body, its json should be decoded to String', () async {
    SharedPreferences.setMockInitialValues({});
    final request = {
      'title': 'foo',
    };
    await _myChuckerHttpClient.post(
      Uri.parse('$_baseUrl$_successPath'),
      body: jsonEncode(request),
    );

    const prettyJson = '''
{
     "request": {
          "title": "foo"
     }
}''';

    final responses = await _sharedPreferencesManager.getAllApiResponses();

    expect(responses.first.prettyJsonRequest, prettyJson);
  });

  test(
      'When request has multippart body, its file details should be added'
      ' in api response model', () async {
    SharedPreferences.setMockInitialValues({});
    final request = MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl$_successPath'),
    );
    request.fields.addAll(
      {'key': '123'},
    );
    request.files.add(
      MultipartFile.fromString(
        'file',
        'file content',
        filename: 'a.png',
      ),
    );
    await _myChuckerHttpClient.send(request);

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

class _MyChuckerHttpClient extends ChuckerHttpClient {
  _MyChuckerHttpClient(Client client) : super(client);

  ///No use, only for mocking purpose
  int statusCode = -1;

  @override
  BaseRequest onRequest(BaseRequest request) {
    request.headers['my-token'] = 'token';
    return request;
  }

  @override
  BaseResponse onResponse(BaseResponse response) {
    statusCode = response.statusCode;
    return response;
  }
}
