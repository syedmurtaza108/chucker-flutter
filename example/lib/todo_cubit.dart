import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:example/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoCubit extends Cubit<List<TodoModel>> {
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

  Future<void> loadData() async {
    try {
      final response = await _dio.get<List<dynamic>>('/todos');

      final list = List<TodoModel>.empty(growable: true);

      if (response.statusCode == 200) {
        response.data?.whereType<Map<String, dynamic>>().forEach((element) {
          list.add(TodoModel.fromJson(element));
        });
      }
      emit(list);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
