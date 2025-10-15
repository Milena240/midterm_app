import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'pages/homework_list_page.dart';
import 'pages/add_homework_page.dart';
import 'blocs/homework_bloc.dart';
import 'blocs/homework_event.dart';
import 'blocs/homework_state.dart';

void main() {
  runApp(const HomeworkApp());
}

class HomeworkApp extends StatelessWidget {
  const HomeworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeworkListPage()),
        GoRoute(path: '/add', builder: (context, state) => const AddHomeworkPage()),
      ],
    );

    return BlocProvider(
      create: (_) => HomeworkBloc(),
      child: MaterialApp.router(
        title: '_Homework Tracker_',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
