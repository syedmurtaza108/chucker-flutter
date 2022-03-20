import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:example/todo_cubit.dart';
import 'package:example/todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [ChuckerObserver.navigatorObserver],
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      onGenerateRoute: (route) {
        switch (route.name) {
          case TodoPage.route:
            return MaterialPageRoute<void>(
              builder: (_) => BlocProvider(
                create: (_) => TodoCubit(),
                child: const TodoPage(),
              ),
              settings: route,
            );
        }
        return null;
      },
      initialRoute: TodoPage.route,
    );
  }
}