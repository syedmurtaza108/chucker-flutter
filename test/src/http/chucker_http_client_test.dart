import 'dart:convert';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
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

  var _prefsNotInitialized = true;

  setUp(() {
    if (_prefsNotInitialized) {
      _client = ChuckerHttpClient(_mockClient);
      _sharedPreferencesManager = SharedPreferencesManager.getInstance();
      _myChuckerHttpClient = _MyChuckerHttpClient(_mockClient);
      _prefsNotInitialized = false;
    }
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
