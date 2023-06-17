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
  const mockedSuccessResponse = {'id': 1};

  const baseUrl = 'https://www.example.com';
  const successPath = '/success';
  const failPath = '/fail';
  const internalErrorPath = '/internal-error';

  final mockClient = MockClient((request) async {
    if (request.url.path == successPath) {
      return Response(
        jsonEncode(mockedSuccessResponse),
        200,
        request: request,
      );
    }
    if (request.url.path == internalErrorPath) {
      return Response(jsonEncode({'error': 'something went wrong'}), 500);
    }
    return Response(emptyString, 400);
  });

  late final chopperClient = chopper.ChopperClient(
    baseUrl: Uri.parse(baseUrl),
    client: mockClient,
    interceptors: [
      ChuckerChopperInterceptor(),
    ],
  );

  late final SharedPreferencesManager sharedPreferencesManager;

  setUpAll(() {
    sharedPreferencesManager = SharedPreferencesManager.getInstance(
      initData: false,
    );
  });
  test('Response should be saved in shared preferences when call succeeds',
      () async {
    SharedPreferences.setMockInitialValues({});
    await chopperClient.get<dynamic, dynamic>(Uri.parse(successPath));

    final responses = await sharedPreferencesManager.getAllApiResponses();

    expect(responses.length, 1);
    expect(responses.first.statusCode, 200);
    expect(responses.first.body, mockedSuccessResponse);
  });

  test('Error should be saved in shared preferences when call fails', () async {
    SharedPreferences.setMockInitialValues({});
    await chopperClient.get<dynamic, dynamic>(Uri.parse(failPath));

    final responses = await sharedPreferencesManager.getAllApiResponses();

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
    await chopperClient.post<dynamic, dynamic>(
      Uri.parse(successPath),
      body: jsonEncode(request),
    );

    const prettyJson = '''
{
     "title": "foo"
}''';

    final responses = await sharedPreferencesManager.getAllApiResponses();

    expect(responses.first.prettyJsonRequest, prettyJson);
  });
}
