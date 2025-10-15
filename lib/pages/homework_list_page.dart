import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../models/homework.dart';
import '../blocs/homework_bloc.dart';
import '../blocs/homework_event.dart';
import '../blocs/homework_state.dart';

class HomeworkListPage extends StatelessWidget {
  const HomeworkListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('__Homework Tracker__')),
      body: BlocBuilder<HomeworkBloc, HomeworkState>(
        builder: (context, state) {
          if (state.homeworks.isEmpty) {
            return const Center(child: Text('Yeah! No homeworks'));
          }
          return ListView.builder(
            itemCount: state.homeworks.length,
            itemBuilder: (context, index) {
              final hw = state.homeworks[index];
              return ListTile(
                title: Text(
                  hw.title,
                  style: TextStyle(
                    decoration: hw.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                subtitle: Text(
                    '${hw.subject} • Due: ${hw.deadline.toLocal().toString().split(' ')[0]}'),
                leading: Checkbox(
                  value: hw.isCompleted,
                  onChanged: (_) {
                    context.read<HomeworkBloc>().add(ToggleHomework(index));
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<HomeworkBloc>().add(DeleteHomework(index));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newHomework = await context.push('/add');
          if (newHomework != null && newHomework is Homework) {
            context.read<HomeworkBloc>().add(AddHomework(newHomework));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
