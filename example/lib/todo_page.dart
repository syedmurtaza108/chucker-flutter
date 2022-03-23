import 'package:chucker_flutter/chucker_flutter.dart';
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
        title: const Text('Chucker Flutter Example'),
      ),
      body: BlocBuilder<TodoCubit, void>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                ChuckerFlutter.chuckerButton,
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: cubit.get,
                  child: const Text('GET'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: cubit.getWithParam,
                  child: const Text('GET WITH PARAMS'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: cubit.post,
                  child: const Text('POST'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: cubit.put,
                  child: const Text('PUT'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: cubit.delete,
                  child: const Text('DELETE'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: cubit.patch,
                  child: const Text('PATCH'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => cubit.get(error: true),
                  child: const Text('ERROR'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
