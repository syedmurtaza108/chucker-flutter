import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/todo_model.dart';
import 'todo_cubit.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({Key? key}) : super(key: key);

  static const route = 'todo-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: () {},
          child: const Text('Chucker'),
        ),
      ),
      body: BlocBuilder<TodoCubit, List<TodoModel>>(
        builder: (context, state) {
          return ListView.separated(
            itemBuilder: (_, i) => Text(state[i].title),
            itemCount: state.length,
            separatorBuilder: (_, __) => const Divider(),
          );
        },
      ),
    );
  }
}
