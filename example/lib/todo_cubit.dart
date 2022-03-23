import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoCubit extends Cubit<void> {
  TodoCubit() : super(List.empty()) {
    _dio.interceptors.add(ChuckerDioInterceptor());
  }

  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      sendTimeout: const Duration(seconds: 30).inMilliseconds,
      connectTimeout: const Duration(seconds: 30).inMilliseconds,
      receiveTimeout: const Duration(seconds: 30).inMilliseconds,
    ),
  );

  Future<void> get({bool error = false}) async {
    try {
      //To produce an error response just adding random string to path
      _dio.get('/post${error ? 'temp' : ''}s/1');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getWithParam() async {
    try {
      //To produce an error response just adding random string to path
      _dio.get('/posts', queryParameters: {
        'userId': 1,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> post() async {
    try {
      await _dio.post(
        '/posts',
        data: {
          'title': 'foo',
          'body': 'bar',
          'userId': 101010,
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> put() async {
    try {
      await _dio.put(
        '/posts/1',
        data: {
          'title': 'PUT foo',
          'body': 'PUT bar',
          'userId': 101010,
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> delete() async {
    try {
      await _dio.delete('/posts/1');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> patch() async {
    try {
      await _dio.patch(
        '/posts/1',
        data: {'title': 'PATCH foo'},
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
