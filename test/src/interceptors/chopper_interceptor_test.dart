import 'dart:convert';

import 'package:chopper/chopper.dart' as chopper;
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:chucker_flutter/src/helpers/constants.dart';
import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const _mockedSuccessResponse = {'id': 1};

  const _baseUrl = 'https://www.example.com';
  const _successPath = '/success';
  const _failPath = '/fail';
  const _internalErrorPath = '/internal-error';

  final _mockClient = MockClient((request) async {
    if (request.url.path == _successPath) {
      return Response(
        jsonEncode(_mockedSuccessResponse),
        200,
        request: request,
      );
    }
    if (request.url.path == _internalErrorPath) {
      return Response(jsonEncode({'error': 'something went wrong'}), 500);
    }
    return Response(emptyString, 400);
  });

  late final _chopperClient = chopper.ChopperClient(
    baseUrl: _baseUrl,
    client: _mockClient,
    interceptors: [
      ChuckerChopperInterceptor(),
    ],
  );

  late final SharedPreferencesManager _sharedPreferencesManager;

  setUpAll(() {
    _sharedPreferencesManager = SharedPreferencesManager.getInstance();
  });
  test('Response should be saved in shared preferences when call succeeds',
      () async {
    SharedPreferences.setMockInitialValues({});
    await _chopperClient.get(_successPath);

    final responses = await _sharedPreferencesManager.getAllApiResponses();

    expect(responses.length, 1);
    expect(responses.first.statusCode, 200);
    expect(responses.first.body, {'data': _mockedSuccessResponse});
  });

  test('Error should be saved in shared preferences when call fails', () async {
    SharedPreferences.setMockInitialValues({});
    await _chopperClient.get(_failPath);

    final responses = await _sharedPreferencesManager.getAllApiResponses();

    expect(responses.length, 1);
    expect(responses.first.statusCode, 400);
  });

//   test(
//       'When request has multipart body, its file details should be added'
//       ' in api response model', () async {
//     SharedPreferences.setMockInitialValues({});
//     await _chopperClient.send(
//       chopper.Request(
//         'POST',
//         _successPath,
//         _baseUrl,
//         parts: <chopper.PartValue>[
//           const chopper.PartValue<String>('key', '123'),
//           chopper.PartValueFile<MultipartFile>(
//             'source',
//             MultipartFile.fromString(
//               'file',
//               'file content',
//               filename: 'a.png',
//             ),
//           )
//         ],
//         multipart: true,
//       ),
//     );

//     const prettyJson = '''
// {
//      "request": [
//           {
//                "key": "123"
//           },
//           {
//                "file": "a.png"
//           }
//      ]
// }''';

//     final responses = await _sharedPreferencesManager.getAllApiResponses();

//     expect(responses.first.prettyJsonRequest, prettyJson);
//   });

  test('When request has body, its json should be decoded to String', () async {
    SharedPreferences.setMockInitialValues({});
    final request = {
      'title': 'foo',
    };
    await _chopperClient.post(
      _successPath,
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
}
