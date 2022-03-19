import 'package:chucker_flutter/src/interceptors/dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/todo_model.dart';

class TodoCubit extends Cubit<List<TodoModel>> {
  TodoCubit() : super(List.empty()) {
    _dio.interceptors.add(ChuckerDioInterceptor());
    loadData();
  }

  final _dio = Dio();

  Future<void> loadData() async {
    try {
      final response = await _dio.get<List<dynamic>>(
        'https://jsonplaceholder.typicode.com/todos',
      );

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
