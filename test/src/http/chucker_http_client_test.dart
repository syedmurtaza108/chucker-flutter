import 'dart:convert';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late final ChuckerHttpClient client;

  const mockedSuccessResponse = {'id': 1};
  const mockedErrorResponse = {'email': 'email is invalid'};

  const baseUrl = 'https://www.example.com';
  const successPath = '/success';
  const failPath = '/fail';
  const internalErrorPath = '/internal-error';

  final mockClient = MockClient((request) async {
    if (request.url.path == successPath) {
      return Response(jsonEncode(mockedSuccessResponse), 200);
    }
    if (request.url.path == internalErrorPath) {
      return Response(jsonEncode({'error': 'something went wrong'}), 500);
    }
    return Response(jsonEncode(mockedErrorResponse), 400);
  });

  late final _MyChuckerHttpClient myChuckerHttpClient;

  late final SharedPreferencesManager sharedPreferencesManager;

  setUpAll(() {
    client = ChuckerHttpClient(mockClient);
    sharedPreferencesManager = SharedPreferencesManager.getInstance(
      initData: false,
    );
    myChuckerHttpClient = _MyChuckerHttpClient(mockClient);
  });
  test('Response should be saved in shared preferences when call succeeds',
      () async {
    SharedPreferences.setMockInitialValues({});
    await client.get(Uri.parse('$baseUrl$successPath'));

    final responses = await sharedPreferencesManager.getAllApiResponses();

    expect(responses.length, 1);
    expect(responses.first.statusCode, 200);
    expect(responses.first.body, mockedSuccessResponse);
  });

  test('Error should be saved in shared preferences when call fails', () async {
    SharedPreferences.setMockInitialValues({});
    await client.get(Uri.parse('$baseUrl$failPath'));

    final responses = await sharedPreferencesManager.getAllApiResponses();

    expect(responses.length, 1);
    expect(responses.first.statusCode, 400);
    expect(responses.first.body, mockedErrorResponse);
  });

  test('Request data should be intercepted when user calls onRequest',
      () async {
    SharedPreferences.setMockInitialValues({});
    await myChuckerHttpClient.get(Uri.parse('$baseUrl$successPath'));

    final responses = await sharedPreferencesManager.getAllApiResponses();
    expect(responses.length, 1);
    expect(responses.first.headers, '{my-token: token}');
  });

  test('Response data should be accessible when user calls onResponse',
      () async {
    expect(myChuckerHttpClient.statusCode, 200);
    SharedPreferences.setMockInitialValues({});
    await myChuckerHttpClient.get(Uri.parse('$baseUrl$internalErrorPath'));

    final responses = await sharedPreferencesManager.getAllApiResponses();
    expect(responses.length, 1);
    expect(myChuckerHttpClient.statusCode, 500);
  });
  test(
      'When UI is running in release mode and showOnRelease is false'
      ' notification should not be shown', () async {
    ChuckerFlutter.isDebugMode = false;
    await myChuckerHttpClient.get(Uri.parse('$baseUrl$internalErrorPath'));
    ChuckerFlutter.isDebugMode = true;
    expect(ChuckerUiHelper.notificationShown, false);
  });

  test('When request has body, its json should be decoded to String', () async {
    SharedPreferences.setMockInitialValues({});
    final request = {
      'title': 'foo',
    };
    await myChuckerHttpClient.post(
      Uri.parse('$baseUrl$successPath'),
      body: jsonEncode(request),
    );

    const prettyJson = '''
{
     "title": "foo"
}''';

    final responses = await sharedPreferencesManager.getAllApiResponses();

    expect(responses.first.prettyJsonRequest, prettyJson);
  });

  test(
      'When request has multippart body, its file details should be added'
      ' in api response model', () async {
    SharedPreferences.setMockInitialValues({});
    final request = MultipartRequest(
      'POST',
      Uri.parse('$baseUrl$successPath'),
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
    await myChuckerHttpClient.send(request);

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
