import 'package:flutter_bloc/flutter_bloc.dart';
import 'homework_event.dart';
import 'homework_state.dart';
import '../models/homework.dart';

class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  HomeworkBloc() : super(const HomeworkState([])) {
    on<AddHomework>((event, emit) {
      final updated = List<Homework>.from(state.homeworks)..add(event.homework);
      emit(HomeworkState(updated));
    });

    on<DeleteHomework>((event, emit) {
      final updated = List<Homework>.from(state.homeworks)..removeAt(event.index);
      emit(HomeworkState(updated));
    });

    on<ToggleHomework>((event, emit) {
      final updated = List<Homework>.from(state.homeworks);
      updated[event.index].isCompleted = !updated[event.index].isCompleted;
      emit(HomeworkState(updated));
    });
  }
}
