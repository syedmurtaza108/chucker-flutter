import 'dart:convert';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:example/chopper/chopper_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  ChuckerFlutter.showOnRelease = true;
  ChuckerFlutter.showNotification = false;
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [ChuckerFlutter.navigatorObserver],
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      home: const TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _baseUrl = 'https://jsonplaceholder.typicode.com';
  var _clientType = _Client.http;

  late final _dio = Dio(
    BaseOptions(
        sendTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': '*',
        }),
  );

  final _chuckerHttpClient = ChuckerHttpClient(http.Client());

  final _chopperApiService = ChopperApiService.create();

  Future<void> get({bool error = false}) async {
    try {
      //To produce an error response just adding random string to path
      final path = '/post${error ? 'temp' : ''}s/1';

      switch (_clientType) {
        case _Client.dio:
          _dio.get('$_baseUrl$path');
          break;
        case _Client.http:
          _chuckerHttpClient.get(Uri.parse('$_baseUrl$path'));
          break;
        case _Client.chopper:
          error ? _chopperApiService.getError() : _chopperApiService.get();
          break;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getWithParam() async {
    try {
      const path = '/posts';

      switch (_clientType) {
        case _Client.dio:
          _dio.get('$_baseUrl$path', queryParameters: {'userId': '1'});
          break;
        case _Client.http:
          _chuckerHttpClient.get(Uri.parse('$_baseUrl$path?userId=1'));
          break;
        case _Client.chopper:
          _chopperApiService.getWithParams();
          break;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> post() async {
    try {
      const path = '/posts';
      final request = {
        'title': 'foo',
        'body': 'bar',
        'userId': '101010',
      };
      switch (_clientType) {
        case _Client.dio:
          await _dio.post('$_baseUrl$path', data: request);
          break;
        case _Client.http:
          _chuckerHttpClient.post(
            Uri.parse('$_baseUrl$path'),
            body: jsonEncode(request),
          );
          break;
        case _Client.chopper:
          _chopperApiService.post(request);
          break;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> put() async {
    try {
      const path = '/posts/1';
      final request = {
        'title': 'PUT foo',
        'body': 'PUT bar',
        'userId': '101010',
      };
      switch (_clientType) {
        case _Client.dio:
          await _dio.put('$_baseUrl$path', data: request);
          break;
        case _Client.http:
          _chuckerHttpClient.put(Uri.parse('$_baseUrl$path'), body: request);
          break;
        case _Client.chopper:
          _chopperApiService.put(request);
          break;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> delete() async {
    try {
      const path = '/posts/1';

      switch (_clientType) {
        case _Client.dio:
          await _dio.delete('$_baseUrl$path');
          break;
        case _Client.http:
          _chuckerHttpClient.delete(Uri.parse('$_baseUrl$path'));
          break;
        case _Client.chopper:
          _chopperApiService.delete();
          break;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> patch() async {
    try {
      const path = '/posts/1';
      final request = {'title': 'PATCH foo'};
      switch (_clientType) {
        case _Client.dio:
          await _dio.patch('$_baseUrl$path', data: request);
          break;
        case _Client.http:
          _chuckerHttpClient.patch(Uri.parse('$_baseUrl$path'), body: request);
          break;
        case _Client.chopper:
          _chopperApiService.patch(request);
          break;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> uploadImage() async {
    try {
      switch (_clientType) {
        case _Client.dio:
          try {
            final formData = FormData.fromMap(
              {
                "key": "6d207e02198a847aa98d0a2a901485a5",
                "source": await MultipartFile.fromFile('assets/logo.png'),
              },
            );
            _dio.post(
              'https://freeimage.host/api/1/upload',
              data: formData,
            );
          } catch (e) {
            debugPrint(e.toString());
          }
          break;
        case _Client.http:
          var request = http.MultipartRequest(
            'POST',
            Uri.parse('https://freeimage.host/api/1/upload'),
          );
          request.fields.addAll(
            {'key': '6d207e02198a847aa98d0a2a901485a5'},
          );
          request.files.add(
            await http.MultipartFile.fromPath(
              'source',
              'assets/logo.png',
            ),
          );

          _chuckerHttpClient.send(request);
          break;
        case _Client.chopper:
          final a = await http.MultipartFile.fromPath(
            'source',
            'assets/logo.png',
          );
          _chopperApiService.imageUpload(a);
          break;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _dio.interceptors.add(ChuckerDioInterceptor());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chucker Flutter Example'),
      ),
      persistentFooterButtons: [
        Text('Using ${_clientType.name} library'),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            setState(
              () {
                switch (_clientType) {
                  case _Client.dio:
                    _clientType = _Client.http;
                    break;
                  case _Client.http:
                    _clientType = _Client.chopper;
                    break;
                  case _Client.chopper:
                    _clientType = _Client.dio;
                    break;
                }
              },
            );
          },
          child: Text(
            'Change to ${_clientType == _Client.dio ? 'Http' : _clientType == _Client.http ? 'Chopper' : 'Dio'}',
          ),
        )
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            ChuckerFlutter.chuckerButton,
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: get,
              child: const Text('GET'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: getWithParam,
              child: const Text('GET WITH PARAMS'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: post,
              child: const Text('POST'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: put,
              child: const Text('PUT'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: delete,
              child: const Text('DELETE'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: patch,
              child: const Text('PATCH'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => get(error: true),
              child: const Text('ERROR'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: uploadImage,
              child: const Text('UPLOAD IMAGE (Chucker Flutter Logo)'),
            ),
            const SizedBox(height: 16),
            Image.asset('assets/logo.png'),
          ],
        ),
      ),
    );
  }
}

enum _Client {
  dio,
  http,
  chopper,
}
