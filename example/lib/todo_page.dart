import 'package:example/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'todo_cubit.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);
  static const route = 'todo-page';

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late final cubit = context.read<TodoCubit>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: cubit.loadData,
            child: const Text('Load Data'),
          )
        ],
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
