import 'dart:convert';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:example/chopper/chopper_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  ChuckerFlutter.showOnRelease = true;
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [ChuckerFlutter.navigatorObserver],
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      home: const TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _baseUrl = 'https://jsonplaceholder.typicode.com';
  var _clientType = _Client.http;

  late final _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      sendTimeout: const Duration(seconds: 30).inMilliseconds,
      connectTimeout: const Duration(seconds: 30).inMilliseconds,
      receiveTimeout: const Duration(seconds: 30).inMilliseconds,
    ),
  );

  final _chuckerHttpClient = ChuckerHttpClient(http.Client());

  final _chopperApiService = ChopperApiService.create();

  Future<void> get({bool error = false}) async {
    try {
      //To produce an error response just adding random string to path
      final path = '/post${error ? 'temp' : ''}s/1';

      switch (_clientType) {
        case _Client.dio:
          _dio.get(path);
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
          _dio.get(path, queryParameters: {'userId': 1});
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
          await _dio.post(path, data: request);
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
          await _dio.put(path, data: request);
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
          await _dio.delete(path);
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
          await _dio.patch(path, data: request);
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
