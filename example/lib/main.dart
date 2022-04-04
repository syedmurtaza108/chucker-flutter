import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:chucker_flutter_ui/chucker_flutter_ui.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
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

  late final _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      sendTimeout: const Duration(seconds: 30).inMilliseconds,
      connectTimeout: const Duration(seconds: 30).inMilliseconds,
      receiveTimeout: const Duration(seconds: 30).inMilliseconds,
    ),
  );

  Future<void> get({bool error = false}) async {
    try {
      //To produce an error response just adding random string to path
      final path = '/post${error ? 'temp' : ''}s/1';
      _dio.get(path);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getWithParam() async {
    try {
      const path = '/posts';

      _dio.get(path, queryParameters: {'userId': 1});
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
      await _dio.post(path, data: request);
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
      await _dio.put(path, data: request);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> delete() async {
    try {
      const path = '/posts/1';

      await _dio.delete(path);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> patch() async {
    try {
      const path = '/posts/1';
      final request = {'title': 'PATCH foo'};
      await _dio.patch(path, data: request);
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
